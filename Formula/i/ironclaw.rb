class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://github.com/nearai/ironclaw/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e60ef7e056f643ccdd7ae0437abd64bad5884ecffde62edac85e2ebd31ec71b8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10bfe073a2a5d539109a8e8b1a66b086f85708db6f7b040022783a3b21740091"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59cbd24cf9d99f00ab24080358af39006c5b92bcf4080ee0bea231697b3c83b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff183e42ef085f94f80b6cae6f0f290021d1137c3c914e17536eb8d339a64352"
    sha256 cellar: :any_skip_relocation, sonoma:        "d25899409f8f26cdd471b2e11ba473ad60bf5d5dd7baed8e9494afe9273e756a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0b0c0cb6b9354883182a4b3b9d5d7aeac9ea7481efaf194a16b1f4149a617a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee41c307265518fe29558b82e36625b529aed3ae9f3f8d2e7693f266be60801d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
