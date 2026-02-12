class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-20.1.0.tgz"
  sha256 "ebdb6fa7481ee6bb77684d31ad80ab50a7e810d6523d1f72caf3e13354abc213"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c09009575b01f257cf5b663f79894f8c5c87b2798662891328707ec6b7a1502a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    config_file = testpath/".wikibase-cli.json"
    config_file.write "{\"instance\":\"https://www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}/wd --version")
  end
end
