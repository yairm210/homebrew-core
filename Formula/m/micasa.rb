class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.54.2.tar.gz"
  sha256 "c09a3f195eb351e0c55bdbd9dbfdf50b4fe4eb960df74afd4942ef17533e3d80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f198477c4192537e75b038f96ce760f4993066ab9253397ab09d64c71b48e067"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f198477c4192537e75b038f96ce760f4993066ab9253397ab09d64c71b48e067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f198477c4192537e75b038f96ce760f4993066ab9253397ab09d64c71b48e067"
    sha256 cellar: :any_skip_relocation, sonoma:        "c84a4aab3a6e27d10fb657c90583b17f5de3bcaa825750d5c11981c8e79535ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ef129e80af643c7f50bfa4e527e9943e5d0698ecc3a4c9b68e5193d8a76f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a1c027ba7fc65312956e5d53c8bccc343f3a708b3a806c9f3bc49fb5bb7d64e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
