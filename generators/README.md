In this directory are implementations of some of the generators listed on [https://openapi-generator.tech/docs/generators](https://openapi-generator.tech/docs/generators).

They are automatically detected and included by `default.nix` in the repo root. It they are not, ensure that you added them out in git, since flakes filter files by git. They are passed as arguments to the function [`greateGenerator`](../docs/createGenerator.md), but the field `generatorName` is automatically set to the directory name, so you can leave it out.

Directory for a generator must be named exactly the same as [here](https://openapi-generator.tech/docs/generators).
