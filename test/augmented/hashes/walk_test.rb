require 'minitest/autorun'
require 'augmented/hashes/walk'
require 'augmented/objects/tackable'

describe Augmented::Hashes::Walk do
  using Augmented::Hashes::Walk
  using Augmented::Objects::Tackable

  let(:monster_tree) do
    {
      a: {
        aa: 1,
        ab: [2, 3],
      },
      b: 'lorem',
      c: {
        ca: {
          caa: {
            'caaa'     => 5.0,
             9999      => :ipsum,
            :caac      => 'dolor',
            ['ca',:ad] => 6,
            {ca:'ae'}  => obj_1,
            obj_2      => nil,
            nil        => [7, :sit, '7'],
          },
          cab: 7.5,
          cac: {
            caca: 'amet',
          },
        },
        cb: [
          {
            cba: true,
            cbb: false,
          },
          {
            cbc: {
              :cbca    => [{'x' => :y}, {u: 'v'}],
              [:cbcb]  => 8,
              ['cbcc'] => [9, {ten: 10}, 11],
            }
          },
        ],
      },
      d: nil,
    }
  end
  let(:obj_1){ Object.new }
  let(:obj_2){ Object.new }

  describe '#walk' do

    it 'traverses the tree in depth-first order by default' do
      tree = monster_tree

      yields_1 = walk_using_block(tree)
      yields_2 = walk_using_enumerator(tree)

      verify_yields(yields_1, yields_2, [
        #d. key         node                 parent               is_leaf root
        [0, root_key,   tree,                nil,                 false,  tree],
        [1, :a,         tree[:a],            tree,                false,  tree],
        [2, :aa,        1,                   tree[:a],            true,   tree],
        [2, :ab,        [2,3],               tree[:a],            true,   tree],
        [1, :b,         'lorem',             tree,                true,   tree],
        [1, :c,         tree[:c],            tree,                false,  tree],
        [2, :ca,        tree[:c][:ca],       tree[:c],            false,  tree],
        [3, :caa,       tree[:c][:ca][:caa], tree[:c][:ca],       false,  tree],
        [4, 'caaa',     5.0,                 tree[:c][:ca][:caa], true,   tree],
        [4, 9999,       :ipsum,              tree[:c][:ca][:caa], true,   tree],
        [4, :caac,      'dolor',             tree[:c][:ca][:caa], true,   tree],
        [4, ['ca',:ad], 6,                   tree[:c][:ca][:caa], true,   tree],
        [4, {ca:'ae'},  obj_1,               tree[:c][:ca][:caa], true,   tree],
        [4, obj_2,      nil,                 tree[:c][:ca][:caa], true,   tree],
        [4, nil,        [7, :sit, '7'],      tree[:c][:ca][:caa], true,   tree],
        [3, :cab,       7.5,                 tree[:c][:ca],       true,   tree],
        [3, :cac,       tree[:c][:ca][:cac], tree[:c][:ca],       false,  tree],
        [4, :caca,      'amet',              tree[:c][:ca][:cac], true,   tree],
        [2, :cb,        tree[:c][:cb],       tree[:c],            true,   tree],
        [1, :d,         nil,                 tree,                true,   tree],
      ])
    end

    it 'can traverse the tree in breadth-first order' do
      tree = monster_tree

      walk_options = { order: :breadth_first }

      yields_1 = walk_using_block(tree, **walk_options)
      yields_2 = walk_using_enumerator(tree, **walk_options)

      verify_yields(yields_1, yields_2, [
        #d. key         node                 parent               is_leaf root
        [0, root_key,   tree,                nil,                 false,  tree],
        [1, :a,         tree[:a],            tree,                false,  tree],
        [1, :b,         'lorem',             tree,                true,   tree],
        [1, :c,         tree[:c],            tree,                false,  tree],
        [1, :d,         nil,                 tree,                true,   tree],
        [2, :aa,        1,                   tree[:a],            true,   tree],
        [2, :ab,        [2,3],               tree[:a],            true,   tree],
        [2, :ca,        tree[:c][:ca],       tree[:c],            false,  tree],
        [2, :cb,        tree[:c][:cb],       tree[:c],            true,   tree],
        [3, :caa,       tree[:c][:ca][:caa], tree[:c][:ca],       false,  tree],
        [3, :cab,       7.5,                 tree[:c][:ca],       true,   tree],
        [3, :cac,       tree[:c][:ca][:cac], tree[:c][:ca],       false,  tree],
        [4, 'caaa',     5.0,                 tree[:c][:ca][:caa], true,   tree],
        [4, 9999,       :ipsum,              tree[:c][:ca][:caa], true,   tree],
        [4, :caac,      'dolor',             tree[:c][:ca][:caa], true,   tree],
        [4, ['ca',:ad], 6,                   tree[:c][:ca][:caa], true,   tree],
        [4, {ca:'ae'},  obj_1,               tree[:c][:ca][:caa], true,   tree],
        [4, obj_2,      nil,                 tree[:c][:ca][:caa], true,   tree],
        [4, nil,        [7, :sit, '7'],      tree[:c][:ca][:caa], true,   tree],
        [4, :caca,      'amet',              tree[:c][:ca][:cac], true,   tree],
      ])
    end

    it 'can omit leaf nodes' do
      tree = monster_tree

      walk_options = { leaves: :omit }

      yields_1 = walk_using_block(tree, **walk_options)
      yields_2 = walk_using_enumerator(tree, **walk_options)

      verify_yields(yields_1, yields_2, [
        #d. key         node                 parent               is_leaf root
        [0, root_key,   tree,                nil,                 false,  tree],
        [1, :a,         tree[:a],            tree,                false,  tree],
        [1, :c,         tree[:c],            tree,                false,  tree],
        [2, :ca,        tree[:c][:ca],       tree[:c],            false,  tree],
        [3, :caa,       tree[:c][:ca][:caa], tree[:c][:ca],       false,  tree],
        [3, :cac,       tree[:c][:ca][:cac], tree[:c][:ca],       false,  tree],
      ])

      walk_options.merge!({ order: :breadth_first })

      yields_1 = walk_using_block(tree, **walk_options)
      yields_2 = walk_using_enumerator(tree, **walk_options)

      verify_yields(yields_1, yields_2, [
        #d. key         node                 parent               is_leaf root
        [0, root_key,   tree,                nil,                 false,  tree],
        [1, :a,         tree[:a],            tree,                false,  tree],
        [1, :c,         tree[:c],            tree,                false,  tree],
        [2, :ca,        tree[:c][:ca],       tree[:c],            false,  tree],
        [3, :caa,       tree[:c][:ca][:caa], tree[:c][:ca],       false,  tree],
        [3, :cac,       tree[:c][:ca][:cac], tree[:c][:ca],       false,  tree],
      ])
    end

    it 'can emit only the leaf nodes' do
      tree = monster_tree

      walk_options = { leaves: :only }

      yields_1 = walk_using_block(tree, **walk_options)
      yields_2 = walk_using_enumerator(tree, **walk_options)

      verify_yields(yields_1, yields_2, [
        #d. key         node                 parent               is_leaf root
        [2, :aa,        1,                   tree[:a],            true,   tree],
        [2, :ab,        [2,3],               tree[:a],            true,   tree],
        [1, :b,         'lorem',             tree,                true,   tree],
        [4, 'caaa',     5.0,                 tree[:c][:ca][:caa], true,   tree],
        [4, 9999,       :ipsum,              tree[:c][:ca][:caa], true,   tree],
        [4, :caac,      'dolor',             tree[:c][:ca][:caa], true,   tree],
        [4, ['ca',:ad], 6,                   tree[:c][:ca][:caa], true,   tree],
        [4, {ca:'ae'},  obj_1,               tree[:c][:ca][:caa], true,   tree],
        [4, obj_2,      nil,                 tree[:c][:ca][:caa], true,   tree],
        [4, nil,        [7, :sit, '7'],      tree[:c][:ca][:caa], true,   tree],
        [3, :cab,       7.5,                 tree[:c][:ca],       true,   tree],
        [4, :caca,      'amet',              tree[:c][:ca][:cac], true,   tree],
        [2, :cb,        tree[:c][:cb],       tree[:c],            true,   tree],
        [1, :d,         nil,                 tree,                true,   tree],
      ])

      walk_options.merge!({ order: :breadth_first })

      yields_1 = walk_using_block(tree, **walk_options)
      yields_2 = walk_using_enumerator(tree, **walk_options)

      verify_yields(yields_1, yields_2, [
        #d. key         node                 parent               is_leaf root
        [1, :b,         'lorem',             tree,                true,   tree],
        [1, :d,         nil,                 tree,                true,   tree],
        [2, :aa,        1,                   tree[:a],            true,   tree],
        [2, :ab,        [2,3],               tree[:a],            true,   tree],
        [2, :cb,        tree[:c][:cb],       tree[:c],            true,   tree],
        [3, :cab,       7.5,                 tree[:c][:ca],       true,   tree],
        [4, 'caaa',     5.0,                 tree[:c][:ca][:caa], true,   tree],
        [4, 9999,       :ipsum,              tree[:c][:ca][:caa], true,   tree],
        [4, :caac,      'dolor',             tree[:c][:ca][:caa], true,   tree],
        [4, ['ca',:ad], 6,                   tree[:c][:ca][:caa], true,   tree],
        [4, {ca:'ae'},  obj_1,               tree[:c][:ca][:caa], true,   tree],
        [4, obj_2,      nil,                 tree[:c][:ca][:caa], true,   tree],
        [4, nil,        [7, :sit, '7'],      tree[:c][:ca][:caa], true,   tree],
        [4, :caca,      'amet',              tree[:c][:ca][:cac], true,   tree],
      ])
    end

    describe 'using the edge finder function that also unfolds arrays of hashes' do

      describe 'it treats arrays of hashes as nodes where each hash is a child linked by an edged labelled with that hash\'s index' do

        it 'walks depth first' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
          }
          yields_1 = walk_using_block(tree, **walk_options)
          yields_2 = walk_using_enumerator(tree, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key         node                    parent                            is_leaf root
            [0, root_key,   tree,                   nil,                              false,  tree],
            [1, :a,         tree[:a],               tree,                             false,  tree],
            [2, :aa,        1,                      tree[:a],                         true,   tree],
            [2, :ab,        [2,3],                  tree[:a],                         true,   tree],
            [1, :b,         'lorem',                tree,                             true,   tree],
            [1, :c,         tree[:c],               tree,                             false,  tree],
            [2, :ca,        tree[:c][:ca],          tree[:c],                         false,  tree],
            [3, :caa,       tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [4, 'caaa',     5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, 9999,       :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, :caac,      'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, ['ca',:ad], 6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, {ca:'ae'},  obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, obj_2,      nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, nil,        [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [3, :cab,       7.5,                    tree[:c][:ca],                    true,   tree],
            [3, :cac,       tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [4, :caca,      'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [2, :cb,        tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, 0,          tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [4, :cba,       true,                   tree[:c][:cb][0],                 true,   tree],
            [4, :cbb,       false,                  tree[:c][:cb][0],                 true,   tree],
            [3, 1,          tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, :cbc,       tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, :cbca,      [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [6, 0,          {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [7, 'x',        :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [6, 1,          {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [7, :u,         'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
            [5, [:cbcb],    8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, ['cbcc'],   [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [1, :d,         nil,                    tree,                             true,   tree],
          ])
        end

        it 'walks breadth first' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
            order: :breadth_first,
          }
          yields_1 = walk_using_block(tree, **walk_options)
          yields_2 = walk_using_enumerator(tree, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key         node                    parent                            is_leaf root
            [0, root_key,   tree,                   nil,                              false,  tree],
            [1, :a,         tree[:a],               tree,                             false,  tree],
            [1, :b,         'lorem',                tree,                             true,   tree],
            [1, :c,         tree[:c],               tree,                             false,  tree],
            [1, :d,         nil,                    tree,                             true,   tree],
            [2, :aa,        1,                      tree[:a],                         true,   tree],
            [2, :ab,        [2,3],                  tree[:a],                         true,   tree],
            [2, :ca,        tree[:c][:ca],          tree[:c],                         false,  tree],
            [2, :cb,        tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, :caa,       tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [3, :cab,       7.5,                    tree[:c][:ca],                    true,   tree],
            [3, :cac,       tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [3, 0,          tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [3, 1,          tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, 'caaa',     5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, 9999,       :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, :caac,      'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, ['ca',:ad], 6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, {ca:'ae'},  obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, obj_2,      nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, nil,        [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [4, :caca,      'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [4, :cba,       true,                   tree[:c][:cb][0],                 true,   tree],
            [4, :cbb,       false,                  tree[:c][:cb][0],                 true,   tree],
            [4, :cbc,       tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, :cbca,      [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [5, [:cbcb],    8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, ['cbcc'],   [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [6, 0,          {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [6, 1,          {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [7, 'x',        :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [7, :u,         'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
          ])
        end

        it 'can omit the leaf nodes' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
            leaves: :omit,
          }
          yields_1 = walk_using_block(tree, **walk_options)
          yields_2 = walk_using_enumerator(tree, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key         node                    parent                            is_leaf root
          [0, root_key,   tree,                   nil,                              false,  tree],
          [1, :a,         tree[:a],               tree,                             false,  tree],
          [1, :c,         tree[:c],               tree,                             false,  tree],
          [2, :ca,        tree[:c][:ca],          tree[:c],                         false,  tree],
          [3, :caa,       tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
          [3, :cac,       tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
          [2, :cb,        tree[:c][:cb],          tree[:c],                         false,  tree],
          [3, 0,          tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
          [3, 1,          tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
          [4, :cbc,       tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
          [5, :cbca,      [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
          [6, 0,          {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
          [6, 1,          {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
          ])

          walk_options.merge!({ order: :breadth_first })
          yields_1 = walk_using_block(tree, **walk_options)
          yields_2 = walk_using_enumerator(tree, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key         node                    parent                            is_leaf root
            [0, root_key,   tree,                   nil,                              false,  tree],
            [1, :a,         tree[:a],               tree,                             false,  tree],
            [1, :c,         tree[:c],               tree,                             false,  tree],
            [2, :ca,        tree[:c][:ca],          tree[:c],                         false,  tree],
            [2, :cb,        tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, :caa,       tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [3, :cac,       tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [3, 0,          tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [3, 1,          tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, :cbc,       tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, :cbca,      [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [6, 0,          {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [6, 1,          {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
          ])
        end

        it 'can emit only the leaf nodes' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
            leaves: :only,
          }
          yields_1 = walk_using_block(tree, **walk_options)
          yields_2 = walk_using_enumerator(tree, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key         node                    parent                            is_leaf root
            [2, :aa,        1,                      tree[:a],                         true,   tree],
            [2, :ab,        [2,3],                  tree[:a],                         true,   tree],
            [1, :b,         'lorem',                tree,                             true,   tree],
            [4, 'caaa',     5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, 9999,       :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, :caac,      'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, ['ca',:ad], 6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, {ca:'ae'},  obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, obj_2,      nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, nil,        [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [3, :cab,       7.5,                    tree[:c][:ca],                    true,   tree],
            [4, :caca,      'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [4, :cba,       true,                   tree[:c][:cb][0],                 true,   tree],
            [4, :cbb,       false,                  tree[:c][:cb][0],                 true,   tree],
            [7, 'x',        :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [7, :u,         'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
            [5, [:cbcb],    8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, ['cbcc'],   [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [1, :d,         nil,                    tree,                             true,   tree],
          ])

          walk_options.merge!({ order: :breadth_first })
          yields_1 = walk_using_block(tree, **walk_options)
          yields_2 = walk_using_enumerator(tree, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key         node                    parent                            is_leaf root
            [1, :b,         'lorem',                tree,                             true,   tree],
            [1, :d,         nil,                    tree,                             true,   tree],
            [2, :aa,        1,                      tree[:a],                         true,   tree],
            [2, :ab,        [2,3],                  tree[:a],                         true,   tree],
            [3, :cab,       7.5,                    tree[:c][:ca],                    true,   tree],
            [4, 'caaa',     5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, 9999,       :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, :caac,      'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, ['ca',:ad], 6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, {ca:'ae'},  obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, obj_2,      nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, nil,        [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [4, :caca,      'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [4, :cba,       true,                   tree[:c][:cb][0],                 true,   tree],
            [4, :cbb,       false,                  tree[:c][:cb][0],                 true,   tree],
            [5, [:cbcb],    8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, ['cbcc'],   [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [7, 'x',        :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [7, :u,         'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
          ])
        end

      end

    end

    describe '#walk_with_keypaths' do

      describe 'it yields the whole key path to a node instead of only its keys' do

        it 'walks depth first' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
          }
          yields_1 = walk_using_block(tree, method: :walk_with_keypaths, **walk_options)
          yields_2 = walk_using_enumerator(tree, method: :walk_with_keypaths, **walk_options)

          r = root_key
          verify_yields(yields_1, yields_2, [
            #d. key_path                       node                    parent                            is_leaf root
            [0, [r],                           tree,                   nil,                              false,  tree],
            [1, [r,:a],                        tree[:a],               tree,                             false,  tree],
            [2, [r,:a,:aa],                    1,                      tree[:a],                         true,   tree],
            [2, [r,:a,:ab],                    [2,3],                  tree[:a],                         true,   tree],
            [1, [r,:b],                        'lorem',                tree,                             true,   tree],
            [1, [r,:c],                        tree[:c],               tree,                             false,  tree],
            [2, [r,:c,:ca],                    tree[:c][:ca],          tree[:c],                         false,  tree],
            [3, [r,:c,:ca,:caa],               tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [4, [r,:c,:ca,:caa,'caaa'],        5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,9999],          :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,:caac],         'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,['ca',:ad]],    6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,{ca:'ae'}],     obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,obj_2],         nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,nil],           [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [3, [r,:c,:ca,:cab],               7.5,                    tree[:c][:ca],                    true,   tree],
            [3, [r,:c,:ca,:cac],               tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [4, [r,:c,:ca,:cac,:caca],         'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [2, [r,:c,:cb],                    tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, [r,:c,:cb,0],                  tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [4, [r,:c,:cb,0,:cba],             true,                   tree[:c][:cb][0],                 true,   tree],
            [4, [r,:c,:cb,0,:cbb],             false,                  tree[:c][:cb][0],                 true,   tree],
            [3, [r,:c,:cb,1],                  tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, [r,:c,:cb,1,:cbc],             tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, [r,:c,:cb,1,:cbc,:cbca],       [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,0],     {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,0,'x'], :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,1],     {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,1,:u],  'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
            [5, [r,:c,:cb,1,:cbc,[:cbcb]],     8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, [r,:c,:cb,1,:cbc,['cbcc']],    [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [1, [r,:d],                        nil,                    tree,                             true,   tree],
          ])
        end

        it 'walks breadth first' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
            order: :breadth_first,
          }
          yields_1 = walk_using_block(tree, method: :walk_with_keypaths, **walk_options)
          yields_2 = walk_using_enumerator(tree, method: :walk_with_keypaths, **walk_options)

          r = root_key
          verify_yields(yields_1, yields_2, [
            #d. key_path                       node                    parent                            is_leaf root
            [0, [r],                           tree,                   nil,                              false,  tree],
            [1, [r,:a],                        tree[:a],               tree,                             false,  tree],
            [1, [r,:b],                        'lorem',                tree,                             true,   tree],
            [1, [r,:c],                        tree[:c],               tree,                             false,  tree],
            [1, [r,:d],                        nil,                    tree,                             true,   tree],
            [2, [r,:a,:aa],                    1,                      tree[:a],                         true,   tree],
            [2, [r,:a,:ab],                    [2,3],                  tree[:a],                         true,   tree],
            [2, [r,:c,:ca],                    tree[:c][:ca],          tree[:c],                         false,  tree],
            [2, [r,:c,:cb],                    tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, [r,:c,:ca,:caa],               tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [3, [r,:c,:ca,:cab],               7.5,                    tree[:c][:ca],                    true,   tree],
            [3, [r,:c,:ca,:cac],               tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [3, [r,:c,:cb,0],                  tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [3, [r,:c,:cb,1],                  tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, [r,:c,:ca,:caa,'caaa'],        5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,9999],          :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,:caac],         'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,['ca',:ad]],    6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,{ca:'ae'}],     obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,obj_2],         nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,nil],           [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:cac,:caca],         'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [4, [r,:c,:cb,0,:cba],             true,                   tree[:c][:cb][0],                 true,   tree],
            [4, [r,:c,:cb,0,:cbb],             false,                  tree[:c][:cb][0],                 true,   tree],
            [4, [r,:c,:cb,1,:cbc],             tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, [r,:c,:cb,1,:cbc,:cbca],       [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [5, [r,:c,:cb,1,:cbc,[:cbcb]],     8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, [r,:c,:cb,1,:cbc,['cbcc']],    [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,0],     {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,1],     {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,0,'x'], :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,1,:u],  'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
          ])
        end

        it 'can omit the leaf nodes' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
            leaves: :omit,
          }
          yields_1 = walk_using_block(tree, method: :walk_with_keypaths, **walk_options)
          yields_2 = walk_using_enumerator(tree, method: :walk_with_keypaths, **walk_options)

          r = root_key
          verify_yields(yields_1, yields_2, [
            #d. key_path                       node                    parent                            is_leaf root
            [0, [r],                           tree,                   nil,                              false,  tree],
            [1, [r,:a],                        tree[:a],               tree,                             false,  tree],
            [1, [r,:c],                        tree[:c],               tree,                             false,  tree],
            [2, [r,:c,:ca],                    tree[:c][:ca],          tree[:c],                         false,  tree],
            [3, [r,:c,:ca,:caa],               tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [3, [r,:c,:ca,:cac],               tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [2, [r,:c,:cb],                    tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, [r,:c,:cb,0],                  tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [3, [r,:c,:cb,1],                  tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, [r,:c,:cb,1,:cbc],             tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, [r,:c,:cb,1,:cbc,:cbca],       [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,0],     {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,1],     {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
          ])

          walk_options.merge!({ order: :breadth_first })
          yields_1 = walk_using_block(tree, method: :walk_with_keypaths, **walk_options)
          yields_2 = walk_using_enumerator(tree, method: :walk_with_keypaths, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key_path                       node                    parent                            is_leaf root
            [0, [r],                           tree,                   nil,                              false,  tree],
            [1, [r,:a],                        tree[:a],               tree,                             false,  tree],
            [1, [r,:c],                        tree[:c],               tree,                             false,  tree],
            [2, [r,:c,:ca],                    tree[:c][:ca],          tree[:c],                         false,  tree],
            [2, [r,:c,:cb],                    tree[:c][:cb],          tree[:c],                         false,  tree],
            [3, [r,:c,:ca,:caa],               tree[:c][:ca][:caa],    tree[:c][:ca],                    false,  tree],
            [3, [r,:c,:ca,:cac],               tree[:c][:ca][:cac],    tree[:c][:ca],                    false,  tree],
            [3, [r,:c,:cb,0],                  tree[:c][:cb][0],       tree[:c][:cb],                    false,  tree],
            [3, [r,:c,:cb,1],                  tree[:c][:cb][1],       tree[:c][:cb],                    false,  tree],
            [4, [r,:c,:cb,1,:cbc],             tree[:c][:cb][1][:cbc], tree[:c][:cb][1],                 false,  tree],
            [5, [r,:c,:cb,1,:cbc,:cbca],       [{'x'=>:y}, {u: 'v'}],  tree[:c][:cb][1][:cbc],           false,  tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,0],     {'x'=>:y},              tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
            [6, [r,:c,:cb,1,:cbc,:cbca,1],     {u: 'v'},               tree[:c][:cb][1][:cbc][:cbca],    false,  tree],
          ])
        end

        it 'can emit only the leaf nodes' do
          tree = monster_tree

          walk_options = {
            edge_finder: Augmented::Hashes::Walk::HASH_ARRAY_UNFOLDING_EDGE_FINDER,
            leaves: :only,
          }
          yields_1 = walk_using_block(tree, method: :walk_with_keypaths, **walk_options)
          yields_2 = walk_using_enumerator(tree, method: :walk_with_keypaths, **walk_options)

          r = root_key
          verify_yields(yields_1, yields_2, [
            #d. key_path                       node                    parent                            is_leaf root
            [2, [r,:a,:aa],                    1,                      tree[:a],                         true,   tree],
            [2, [r,:a,:ab],                    [2,3],                  tree[:a],                         true,   tree],
            [1, [r,:b],                        'lorem',                tree,                             true,   tree],
            [4, [r,:c,:ca,:caa,'caaa'],        5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,9999],          :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,:caac],         'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,['ca',:ad]],    6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,{ca:'ae'}],     obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,obj_2],         nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,nil],           [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [3, [r,:c,:ca,:cab],               7.5,                    tree[:c][:ca],                    true,   tree],
            [4, [r,:c,:ca,:cac,:caca],         'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [4, [r,:c,:cb,0,:cba],             true,                   tree[:c][:cb][0],                 true,   tree],
            [4, [r,:c,:cb,0,:cbb],             false,                  tree[:c][:cb][0],                 true,   tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,0,'x'], :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,1,:u],  'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
            [5, [r,:c,:cb,1,:cbc,[:cbcb]],     8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, [r,:c,:cb,1,:cbc,['cbcc']],    [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [1, [r,:d],                        nil,                    tree,                             true,   tree],
          ])

          walk_options.merge!({ order: :breadth_first })
          yields_1 = walk_using_block(tree, method: :walk_with_keypaths, **walk_options)
          yields_2 = walk_using_enumerator(tree, method: :walk_with_keypaths, **walk_options)

          verify_yields(yields_1, yields_2, [
            #d. key_path                       node                    parent                            is_leaf root
            [1, [r,:b],                        'lorem',                tree,                             true,   tree],
            [1, [r,:d],                        nil,                    tree,                             true,   tree],
            [2, [r,:a,:aa],                    1,                      tree[:a],                         true,   tree],
            [2, [r,:a,:ab],                    [2,3],                  tree[:a],                         true,   tree],
            [3, [r,:c,:ca,:cab],               7.5,                    tree[:c][:ca],                    true,   tree],
            [4, [r,:c,:ca,:caa,'caaa'],        5.0,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,9999],          :ipsum,                 tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,:caac],         'dolor',                tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,['ca',:ad]],    6,                      tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,{ca:'ae'}],     obj_1,                  tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,obj_2],         nil,                    tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:caa,nil],           [7, :sit, '7'],         tree[:c][:ca][:caa],              true,   tree],
            [4, [r,:c,:ca,:cac,:caca],         'amet',                 tree[:c][:ca][:cac],              true,   tree],
            [4, [r,:c,:cb,0,:cba],             true,                   tree[:c][:cb][0],                 true,   tree],
            [4, [r,:c,:cb,0,:cbb],             false,                  tree[:c][:cb][0],                 true,   tree],
            [5, [r,:c,:cb,1,:cbc,[:cbcb]],     8,                      tree[:c][:cb][1][:cbc],           true,   tree],
            [5, [r,:c,:cb,1,:cbc,['cbcc']],    [9, {ten: 10}, 11],     tree[:c][:cb][1][:cbc],           true,   tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,0,'x'], :y,                     tree[:c][:cb][1][:cbc][:cbca][0], true,   tree],
            [7, [r,:c,:cb,1,:cbc,:cbca,1,:u],  'v',                    tree[:c][:cb][1][:cbc][:cbca][1], true,   tree],
          ])
        end

      end

    end

  end

  private

  def walk_using_block tree, method: :walk, **walk_options
    [].tap do |yields|
      tree.__send__(method, **walk_options) do |node, key, parent, depth, is_leaf, root|
        yields << [depth, key, node, parent, is_leaf, root]
      end
    end
  end

  def walk_using_enumerator tree, method: :walk, **walk_options
    tree.__send__(method, **walk_options).map do |node, key, parent, depth, is_leaf, root|
      [depth, key, node, parent, is_leaf, root]
    end
  end

  def verify_yields yields_1, yields_2, expected_yields
    expected_yields.zip(yields_1, yields_2) do |expected, actual_1, actual_2|
      assert_equal expected, actual_1
      assert_equal expected, actual_2
    end
    assert_equal expected_yields.size, yields_1.size
    assert_equal expected_yields.size, yields_2.size
  end

  def root_key
    @root_key ||= Object.new.tack :== do |thing|
      Augmented::Hashes::Walk::RootKey === thing && thing.respond_to?(:root?)
    end
  end

end