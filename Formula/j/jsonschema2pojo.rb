class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "https://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.3.3/jsonschema2pojo-1.3.3.tar.gz"
  sha256 "877924359f7f3faf4a95d95df1d9fd074ede64c0f982fa86408299e9442775c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/jsonschema2pojo[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edb99d1265ef939c0501a99a4a0a957fdad8bd6be1e113af05e91a3a92c55a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb99d1265ef939c0501a99a4a0a957fdad8bd6be1e113af05e91a3a92c55a14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb99d1265ef939c0501a99a4a0a957fdad8bd6be1e113af05e91a3a92c55a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "edb99d1265ef939c0501a99a4a0a957fdad8bd6be1e113af05e91a3a92c55a14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d59cbeb207969062c0e70ad795e40caa8c0cd218dc7cec8737d31b5a66ddda38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59cbeb207969062c0e70ad795e40caa8c0cd218dc7cec8737d31b5a66ddda38"
  end

  depends_on "openjdk"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    bin.write_jar_script libexec/"lib/jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
  end

  test do
    (testpath/"src/jsonschema.json").write <<~JSON
      {
        "type":"object",
        "properties": {
          "foo": {
            "type": "string"
          },
          "bar": {
            "type": "integer"
          },
          "baz": {
            "type": "boolean"
          }
        }
      }
    JSON
    system bin/"jsonschema2pojo", "-s", "src", "-t", testpath
    assert_path_exists testpath/"Jsonschema.java", "Failed to generate Jsonschema.java"
  end
end
