## [Unreleased]

- BREAKING: updated minimum Ruby version required to 2.7.
- BREAKING: removed `Hash#map_values` and `Hash#map_keys`.
- BREAKING: removed `Proc#|`.
- BREAKING: removed `Object#thru` and renamed `#thru_if`, `#thru_unless` to `#then_if`, `#then_unless`.
- BREAKING: renamed the `Objects::Thru` module to `Objects::ThenIf`
- BREAKING: renamed the `Objects::Tappable` module to `Objects::TapIf`
- BREAKING: `Exception#details=` and `Exception#details=` now enforce their argument to be a Hash.

## [0.2.7] - 2021-06-26

- Added `String#squish` and `String#squish!`.
- Added `Object#in?`.

## [0.2.6] - 2021-06-23

- Fixed `String#blank?` not working on Ruby 2.3.

## [0.2.5] - 2021-05-30

- Added `Exception#details`, `Exception#details=`, `Exception#detailed`
- Added `Exception#chain`
- Added `Exception#to_h`

## [0.2.3] - 2021-05-29

- Added `String#truncate`, `String#truncate!` and `String#blank?`
