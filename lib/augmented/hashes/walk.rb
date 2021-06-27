require 'augmented/objects/in'

module Augmented
  module Hashes
    module Walk
      using Objects::In

      refine Hash do

        def walk order: :depth_first, leaves: :emit, edge_finder: HASH_UNFOLDING_EDGE_FINDER, &block
          raise ArgumentError, "`order` must be one of `#{ORDER_OPTIONS}`" unless order.in?(ORDER_OPTIONS)
          raise ArgumentError, "`leaves` must be one of `#{LEAVES_OPTIONS}`" unless leaves.in?(LEAVES_OPTIONS)

          enumerator = Enumerator.new do |yielder|
            root = self
            work = []

            add_work = if order == :depth_first
              -> *tuple { work.unshift(tuple) }
            else
              -> *tuple { work.push(tuple) }
            end

            take_work = -> do
              begin
                unless work.empty?
                  edges, depth, parent = work.first
                  [*edges.next, depth, parent]
                end
              rescue StopIteration
                work.shift
                retry
              end
            end

            root_edges = { RootKey.new => root }.each_pair.extend(EdgeEnumerator)
            add_work.(root_edges, 0, nil)

            while (key, thing, depth, parent = take_work.())
              if (enumerator = edge_finder.(thing)).is_a?(EdgeEnumerator)
                add_work.(enumerator, depth.succ, thing)
                yielder.yield(thing, key, parent, depth, false, root) unless leaves == :only
              else
                yielder.yield(thing, key, parent, depth, true,  root) unless leaves == :omit
              end
            end
          end

          block_given? ? enumerator.each(&block) : enumerator
        end

        def walk_with_keypaths order: :depth_first, leaves: :emit, edge_finder: HASH_UNFOLDING_EDGE_FINDER, &block
          walk(order: order, leaves: :emit, edge_finder: edge_finder).then do |walker|
            Enumerator.new do |yielder|
              key_paths = Hash.new{[]}

              begin
                loop do
                  node, key, parent, depth, is_leaf, root = walker.next

                  key_path = key_paths.store(node.object_id, key_paths[parent.object_id].dup.push(key))

                  unless (leaves == :omit && is_leaf) || (leaves == :only && !is_leaf)
                    yielder.yield(node, key_path, parent, depth, is_leaf, root)
                  end
                end
              rescue StopIteration
                # nothing else to do
              end
            end
          end
          .tap do |enumerator|
            block_given? ? enumerator.each(&block) : enumerator
          end
        end

      end

      HASH_UNFOLDING_EDGE_FINDER = -> thing do
        Hash === thing ? thing.each_pair.extend(EdgeEnumerator) : thing
      end
      HASH_ARRAY_UNFOLDING_EDGE_FINDER = -> thing do
        case thing
        when Hash
          thing.each_pair.extend(EdgeEnumerator)
        when Array
          if thing.all?(&Hash.method(:===))
            thing.each_with_index.lazy.map{[_2,_1]}.extend(EdgeEnumerator)
          else
            thing
          end
        else
          thing
        end
      end

      ORDER_OPTIONS  = %i(depth_first breadth_first)
      LEAVES_OPTIONS = %i(emit omit only)
      private_constant :ORDER_OPTIONS, :LEAVES_OPTIONS

      module EdgeEnumerator
        # used as a marker for enumerators that yield [edge, node] pairs
      end

      class RootKey
        def root?
          true
        end
      end

    end
  end
end