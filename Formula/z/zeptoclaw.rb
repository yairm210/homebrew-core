class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "db273080064dc41640fe70213c5cdf931cb58d761c104f66e5fd62b48117d304"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de8f400b04ee5ebd840c569f2bcc662eb045ae796302b9ed65fcf33604f3892a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f1c0a5af33234c875b1818cca6ac00e3dcd1b2bf7ef3f6c220c6418cf04707d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92c044ee909f9452cbeddd22d240ae74ec6031ab472149361eba6621807a0a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "6254c1b27384e0132dbfc257f004633d27b4f2c8eca64f41125de4343e144985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45193046720f00d639144246c5d540b64e9d9d25288de2fe42f9539f656c7a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee50997505d86885cb22f96df134a5d9eb946e5c1fea740f7ed19e711931b219"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
