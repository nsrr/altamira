## 5.0.1

### Enhancements
- **Gem Changes**
  - Update to rack 2.2.3
  - Update to rake 13.0.3
  - Update to simplecov 0.21.2

## 5.0.0 (April 18, 2021)

### Enhancements
- **Gem Changes**
  - Update to ruby 3.0.1

## 4.0.0 (March 1, 2019)

### Enhancements
- **Gem Changes**
  - Update to ruby 2.6.1
  - Update to edfize 0.6.0
  - Update to simplecov 0.16.1
  - Update to bootstrap 4.3.1

### Bug Fix
- Fix an issue encoding cookies that prevented granting access to EDF files

## 3.0.0 (January 6, 2017)

### Enhancements
- **General Changes**
  - Greatly improved the speed at which signals are drawn on the HTML5 canvas
  - Improved staging file lookup
  - Signals with negative gains now swap their physical minimum and physical
    maximum when autoscaling is off
  - Sleep stages for hypnograms are now loaded directly from XML Annotation
    files
  - Added ability to view 2 minute and 5 minute windows
- **Gem Changes**
  - Updated to Ruby 2.4.0
  - Updated to edfize 0.4.0
  - Updated to rack 2.0.1
  - Updated to sprockets 3.7.0
  - Updated to turbolinks-source 5.0.0
  - Updated to rake 12.0.0
  - Removed minitest-reporters

## 2.0.0 (December 5, 2016)

### Enhancements
- **Gem Changes**
  - Updated to Ruby 2.3.3
  - Updated simplecov to 0.12.0
  - Set turbolinks dependency to 2.5.3

## 1.0.0 (March 12, 2015)

### Enhancements
- Added basic testing framework for rack app
- Added ability to load an EDF signal into an HTML canvas
- Added ability to navigate through EDF using right and left arrows and turbolinks
- Added ability to load and view sleep stages
- Specified max samples per data record to 128
- Added ability to auto scale specific signals by using the auto paramter:
  - `&auto=SIGNALONE|SIGNALTWO`
- Added hypnogram visualization and navigation by clicking on the hypnogram
- EDF access is now controlled directly through the NSRR website
- **Gem Changes**
  - Updated to edfize 0.2.0
    - edfize 0.2.0 provides the ability to load individual epochs from an EDF
- Use of Ruby 2.2.1 is now recommended
