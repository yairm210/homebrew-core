class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "7593def330e7d4dfcb24eb44c451f4e078269e8738ad89e3d84c7031945eeae8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f940488fb39449bab5fb49351179b34ae7867a8c768df994ff4b58cb818e38a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f940488fb39449bab5fb49351179b34ae7867a8c768df994ff4b58cb818e38a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f940488fb39449bab5fb49351179b34ae7867a8c768df994ff4b58cb818e38a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28cff857cb2585362ff42e7fe766efeaaeb2db6aa2680b7c380bc00b8a930cfb"
    sha256 cellar: :any,                 x86_64_linux:  "fa98b6dc6f77afa800b547cb5837de2e367da4c03a0ec936b7122fd0afd02a11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
