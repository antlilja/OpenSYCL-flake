{
  description = "OpenSycl";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }: {
      defaultPackage.x86_64-linux = 
        with import nixpkgs { 
          system = "x86_64-linux"; 
          config.allowUnfree = true;
        };
        llvmPackages.libcxxStdenv.mkDerivation rec {
            name = "OpenSYCL";
            version = "v0.9.4";
            src = builtins.fetchTarball {
                url = "https://github.com/OpenSYCL/OpenSYCL/archive/85f4f5311274bcf38ba8a6914bbaa87e5a1938b9.tar.gz";
                sha256 = "0fnfv2l0g65s58cv2x1rgkglapj0ja81b3rghfqfyvb83f017zpb";
            };

            nativeBuildInputs = [
              cmake
              cudaPackages.autoAddOpenGLRunpathHook
            ];
            buildInputs = [
              llvmPackages.llvm
              llvmPackages.libclang
              llvmPackages.openmp
              boost  
              cudaPackages.cudatoolkit
              python310Packages.python
              cudaPackages.autoAddOpenGLRunpathHook
            ];

            cmakeFlags = [
              "-DCLANG_INCLUDE_PATH=${llvmPackages.libclang}"
            ];
        };
  };
}
