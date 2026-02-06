class Cdb < Formula
  desc "Create and read constant databases"
  homepage "https://cdb.cr.yp.to/"
  url "https://cdb.cr.yp.to/cdb-20251021.tar.gz"
  sha256 "8e531d6390bcd7c9a4cbd16fed36326eee78e8b0e5c0783a8158a6a79437e3dd"
  # https://cdb.cr.yp.to/license.html
  license any_of: [
    :public_domain, # LicenseRef-PD-hp - https://cr.yp.to/spdx.html
    "CC0-1.0",
    "0BSD",
    "MIT-0",
    "MIT",
  ]

  livecheck do
    url "https://cdb.cr.yp.to/download.html"
    regex(/href=.*?cdb[._-]v?(\d{8})\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "77ead498a54dabedd9d9692d71df773d9988ef4a8153f076466a554b818984c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ea510b1e7233cd4f071d380ee73c44e72ea5d220798faa58ee7ac41280350f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a7bad3e2c174916e5e286dcf7e7d576a9996f8f199cf001b91d8232e0719c46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7516272a59a2e3f387bd50b183a2238d9c5333b788cd1f3484ca15ca3c198c8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6641aee9a21258f66441e250aa172ea092731be3ead3ae1b85393188d16dd61d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9136d67f3a62785add35b9b205169b9ace86da2c86edf4fe1c16cb833465bf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "18e027480cd5c20f0bda1d96fbb527596dda5f724f910a8d5062daf16dc7defb"
    sha256 cellar: :any_skip_relocation, ventura:        "88b43291068dbbea67161b415370ea6d09c0663ab3ec8eb052ff02bb8df9bec4"
    sha256 cellar: :any_skip_relocation, monterey:       "6417a2118fe06cb58aaa4a1d8181e9192c6598b4b8712ee2e3fdba0537996aaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9684789ff31a9f66e863c5ddce337ddc056fbea3f2d321d5752a6ec00a3d88c1"
    sha256 cellar: :any_skip_relocation, catalina:       "055cbaab9c15fe3f4b29dac36558497937eea6643c8ccf0cc4a9ee2c427fcff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5d6ce5f6553dc71dabdde82a193e896ca52984ddfd00566aae92429c2bc008d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39c6409d00f0176fd3bd2def3b15b555d5ea89d3b0f6dc9710f1ce61a442e99"
  end

  def install
    inreplace "conf-home", "/usr/local", prefix
    system "make", "setup"

    man1.install Dir["doc/man/*.1"]
    man3.install Dir["doc/man/*.3"]
    prefix.install_metafiles "doc"
    rm "README.md" # install doc/readme.md instead
  end

  test do
    record = "+4,8:test->homebrew\n\n"
    pipe_output("#{bin}/cdbmake db dbtmp", record, 0)
    assert_path_exists testpath/"db"
    assert_equal record, pipe_output("#{bin}/cdbdump", (testpath/"db").binread, 0)
  end
end
