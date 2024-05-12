# `createGeneratorsSet` function

This is a helper function for creating the [`generators`](generators.md) field. \
It also ensures that `generatorName` and the key are the same

So instead of this:

```nix
generators = {
    "cpp-qt-client" = createGenerator {
        generatorName = "cpp-qt-client";
        binaryOverrides = { src, ... } : {
            nativeBuildInputs = with pkgs; [ cmake libsForQt5.qtbase libsForQt5.wrapQtAppsHook ];
            src = "${src}/client";
        };
    };
};
```

I could just write this:

```nix
generators-new = {
    "cpp-qt-client" = {
        binaryOverrides = { src, ... } : {
            nativeBuildInputs = with pkgs; [ cmake libsForQt5.qtbase libsForQt5.wrapQtAppsHook ];
            src = "${src}/client";
        };
    }
}
```
