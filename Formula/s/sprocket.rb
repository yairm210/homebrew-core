class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.21.0",
      revision: "ed1858bb03ced228fee2ed0abbd1a2ce93f76d96"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acc7a3e6ace2821248944812e8a5a52ab3f490d9d9ead92ac0c5db64f4a548de"
    sha256 cellar: :any,                 arm64_sequoia: "1cb15e18afbe5be054ea53e97a48b51a8d22a2cbe14168b06c108591cb7e83ee"
    sha256 cellar: :any,                 arm64_sonoma:  "5c61d5133893cd944fd253da35d6e1b5546f9e6693a9a198910c124fe9a97263"
    sha256 cellar: :any,                 sonoma:        "94902a0775a49ba899845dddabb745beb644344963c8e057081ba8e268235792"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2b06f4a40b6ec39b1de50d17fdaca4f2660a6d10d5d9ef71de332bbc12f9e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc739c834be30411a68356fac13bde487265e3cb82e3a797edd0cc86c0df6e50"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sprocket --version")
    (testpath/"hello.wdl").write <<~WDL
      version 1.2

      task say_hello {
        input {
          String greeting
          String name
        }

        command <<<
          echo "~{greeting}, ~{name}!"
        >>>

        output {
          String message = read_string(stdout())
        }

        runtime {
          container: "ubuntu:latest"
        }
      }
    WDL

    expected = <<~JSON.strip
      {
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end
