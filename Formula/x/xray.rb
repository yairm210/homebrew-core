class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.1.31.tar.gz"
  sha256 "2aaa75d67bf590f46e1d0c9ea8d15ed6761585f3c94111e70c111c269e2b4433"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43adb46453bcb80dab3220b262f5ada06ce3f996f27c53b66722eb62c5798e0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43adb46453bcb80dab3220b262f5ada06ce3f996f27c53b66722eb62c5798e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43adb46453bcb80dab3220b262f5ada06ce3f996f27c53b66722eb62c5798e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85ff610b1a33344a3dfa6fd8641865d5494540ece7f5f41c75b609fa27c97a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2f22b36687953fe98d6d35a30c8d17455bcc8a083c7df684efba02fc4e73e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786368ff212b93b8ec9487c0b1a8e34ac605d2b667e6a4d03c814bf884a1e445"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202601220433/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260131100437/dlc.dat"
    sha256 "e183d477aa4c149a7c809cc2f31b82e6bb22c492421eb96d38c72f4904b4c31c"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.44.1/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    JSON
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
