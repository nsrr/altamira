## 0.1.0

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
  - Updated to edfize 0.2.0.beta1
    - edfize 0.2.0 provides the ability to load individual epochs from an EDF
- Use of Ruby 2.1.3 is now recommended
