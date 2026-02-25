class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "a326059ecef7b33443bcbb96e5b8a7dad62122c4d01480451c6d4cc865e580b0"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1016d71c21c7cd08865d60ae13cf35e8a82e738e714beb13e36301473d493021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022edde57a3438dc21fecaa5cd7bd1037b5cb6c6e482f2b26801ef2a8e34d081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "238269c4b6a8f6f1d6b7dc3855b19c1efcf5cfc0b262f64320b63529009d4e4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a55bc69d66adfc83208c88a2e68e743a6e7149b3b810e196507b41a4338e97e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a9c12107bdfa315398b65b5151dd81cb2d6ebff8ef252cf1a39741f542b019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfbbbf375bbd63e099885e5073d857793625e3e499df5cfd23ae8711cd8cab81"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-cli")
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end
