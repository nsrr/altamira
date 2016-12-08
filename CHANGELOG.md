## 0.3.0

### Enhancements
- **Gem Changes**
  - Updated to edfize 0.4.0
  - Updated to rack 2.0.1
  - Updated to sprockets 3.7.0
  - Updated to turbolinks-source 5.0.0
  - Updated to rake 12.0.0
  - Removed minitest-reporters

## 0.2.0 (December 5, 2016)

### Enhancements
- **Gem Changes**
  - Updated to Ruby 2.3.3
  - Updated simplecov to 0.12.0
  - Set turbolinks dependency to 2.5.3

## 0.1.0 (March 12, 2015)

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
