# BrightVol
Registers an Activator listener that reverses the value of a variable (`brightnessMode`). When it's `YES`, the behavior of the volume keys is modified to change the screen brightness instead. A NSTimer is scheduled every time a volume key is pressed so that `brightnessMode` is reset to `NO` after 30 seconds of not pressing volume keys.

## License
Licensed under the Apache License, version 2.0. Refer to [LICENSE.md](LICENSE.md).
