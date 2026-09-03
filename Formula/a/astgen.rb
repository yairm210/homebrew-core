class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen-monorepo"
  url "https://github.com/joernio/astgen-monorepo/archive/refs/tags/javascript-astgen/v3.49.0.tar.gz"
  sha256 "8ba03a5258151a0dc520511fd5d13192b1b318d6a442acc91fb4dc9ff9d728cd"
  license "Apache-2.0"
  head "https://github.com/joernio/astgen-monorepo.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^javascript[._-]astgen/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cecdb58c1cbee3ab8a97cea19079b401fe2da5fc4f241b0ba0b68b713e4c38d0"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    cd "javascript-astgen" do
      system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
      system "bun", "run", "binary"

      os = OS.mac? ? "macos" : "linux"
      arch = Hardware::CPU.arm? ? "arm64" : "x64"

      bin.install "astgen-#{os}-#{arch}" => "astgen"
    end
  end

  test do
    (testpath/"main.js").write <<~JS
      console.log("Hello, world!");
    JS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match "\"fullName\":\"#{testpath}/main.js\"", (testpath/"out/main.js.json").read
    assert_match '"0:7":"Console"', (testpath/"out/main.js.typemap").read
  end
end
