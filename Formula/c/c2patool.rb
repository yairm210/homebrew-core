class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.19.tar.gz"
  sha256 "c5ac81c81e73b0b6155c59daedd2ee923122b8351bdf3b63a832cc3543abad99"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f99dcc0ab6e1f9ecc8fd77d205da43b0618cb653f7e40c322d68de3674b1b8ef"
    sha256 cellar: :any, arm64_sequoia: "d01b24f32536c0f7245f8e4418984d93ffa9f710b98e15e1da429c794407c2f5"
    sha256 cellar: :any, arm64_sonoma:  "76368a9418e3d5095fa43cd379969b1ed8d89efd4dd3550e1092835a8b442dc2"
    sha256 cellar: :any, arm64_linux:   "d48a321ce224e1f2c7dea66dc1dfce9523369cec76e2f63ac0e0db035a79863e"
    sha256 cellar: :any, x86_64_linux:  "afec55838f900fed042c3089e54620cc4bfca886f708deb2d28b86a798a7799b"
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
