class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https://github.com/helmfile/vals"
  url "https://github.com/helmfile/vals/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "bab93c803f2a838294d0c9c1a42032adaeffd2fe7e6410e8c2dc983e84eac2cf"
  license "Apache-2.0"
  head "https://github.com/helmfile/vals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a0b9830f5748a6ce5734f8490503841c9a3ae11cdcecf3b4f2824cfb5c38d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a0b9830f5748a6ce5734f8490503841c9a3ae11cdcecf3b4f2824cfb5c38d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a0b9830f5748a6ce5734f8490503841c9a3ae11cdcecf3b4f2824cfb5c38d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef099b1387ec5c82af66fe73d21b445c97bc805d8d0382488694d91f4a3eb57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0594edcc66783a523220d4fbd094bface3c7cb710ff6409d6c660be8e944616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbf29eefe7741d96e842a80a01f487f32811a869fe7d453a1e7c0b0b3df9a16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/vals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vals version")

    (testpath/"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}/vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath/"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}/vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end
