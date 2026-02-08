class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "5630918983982e37fa07151ed5969dbc5e0c3de9670abc6381b5d689d979bc2a"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "555ee5898718e26c0a3262811a525fd6437d9dd92b11a53e6088d46529767670"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ce3e4719a42fecef050e2f25a420b360942f1519a966d447ef8eb8d179d36f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efeb24529b28b1b26659c50d4c968896ac4ca52d9f0b729dd63a98af13644044"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca2c31cac8709b566710667e2964f3aa452543db6ca84babd85f67c20481715e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c817832da50f554593f29620861cd62eee65f5a13abc33e220ed8f354de08b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b276d8dfe6a020071c7a192acb5784ac38ce929f4f76e8695f3d84f55823fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
