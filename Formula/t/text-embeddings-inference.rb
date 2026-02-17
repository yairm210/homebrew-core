class TextEmbeddingsInference < Formula
  desc "Blazing fast inference solution for text embeddings models"
  homepage "https://huggingface.co/docs/text-embeddings-inference/quick_tour"
  url "https://github.com/huggingface/text-embeddings-inference/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "68876328e38cc1be97d6327acfa359496843f0513bcf626f8b3d6749c5818b5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81c9457792778ebc3510ef1773e8e89d1a68daf2766f153d4ca89d25d437162c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62ee83ad6ad05907fe27a7a44b436736c0202894604a00e4453603c8a1e62ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "622857fe4c35eb365c7d12bc62a54c6ee9c31c5e7ee355b921a55840cbb8588a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7eaea320c92543e601aecde2fc4c267a5478a59f400ddc6be0f03361fc45d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad0112d50c165440cf752c3309b532ff6f1474d56520aa44e6337da69897f0a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f0c917147f30ff7834c90530434094e932761f8e236a2c7ae0e3f9e17b8916"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    args = (OS.mac? && Hardware::CPU.arm?) ? ["-F", "metal"] : []
    system "cargo", "install", *std_cargo_args(path: "router"), "-F", "candle", *args
  end

  test do
    port = free_port
    spawn bin/"text-embeddings-router", "-p", port.to_s, "--model-id", "sentence-transformers/all-MiniLM-L6-v2"

    sleep 2 if OS.mac? && Hardware::CPU.intel?

    data = "{\"inputs\":\"What is Deep Learning?\"}"
    header = "Content-Type: application/json"
    retries = "--retry 5 --retry-connrefused"
    assert_match "[[", shell_output("curl 127.0.0.1:#{port}/embed -X POST -d '#{data}' -H '#{header}' #{retries}")
  end
end
