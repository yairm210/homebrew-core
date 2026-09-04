class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.18.tar.gz"
  sha256 "fcde7b3de1b312a162c998dc069e73165d3a11e731cb5077672eb41a726079f3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3797c0a495e4a6a52cb87282ec9cbb729287e5b29665240b8bb6b5dcc2b48ef8"
    sha256 cellar: :any, arm64_sequoia: "489e3ec1077e50c4e00ab49ad29365f11b31ba0ba43ca63021681fc75c1beee0"
    sha256 cellar: :any, arm64_sonoma:  "ae0b112c78c92fba960974db6067047e57d89a24d4aba3f2e53744520cd3f53b"
    sha256 cellar: :any, arm64_linux:   "1c5a6671a74dddef38402b20668eda38f8a2746eff4b334b6362f398022bd929"
    sha256 cellar: :any, x86_64_linux:  "70327fe4f4640d80e24ae61a9d9bc1c0cdae182f031a5c539d14b725536af852"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end
