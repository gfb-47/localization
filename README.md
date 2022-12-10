# Localization Challenge

Flutter Version: Flutter 3.3.9

## Getting Started

First things first, you may need to add a file at "android/app/src/main/res/values/keys.xml". And then  add the code down below inserting a Google Maps APIKEY which can be created [here](https://mapsplatform.google.com/).

The challenge description mentioned that it wasn't necessary to use any API Keys, from my research, this is not possible since July 2018. So I came up with this .xml so I wouldn't expose my API Key to the whole web.

```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="google_maps_key" translatable="false" templateMergeStrategy="preserve">
        PASTE YOUR KEY HERE
    </string>
</resources>
```

## Could be improved

- [ ] If the user didn't allowed localization permissions, show a modal which will guide the user to permission settings of the device.
- [ ] 