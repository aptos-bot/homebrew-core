class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "a95d6faad4b292b5dd16789fc2cae1615dc77c6ec3923067d56d228e2bcb8d8b"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f82a3b2a523e105f931fc045d5af9de18115117fdb2b96aaaabc50523fc4fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f82a3b2a523e105f931fc045d5af9de18115117fdb2b96aaaabc50523fc4fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f82a3b2a523e105f931fc045d5af9de18115117fdb2b96aaaabc50523fc4fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd781742c5fd2b4834c832225e35a13e0bd8d834d974da9c1e4f90c807f2cb6"
    sha256 cellar: :any_skip_relocation, ventura:       "6cd781742c5fd2b4834c832225e35a13e0bd8d834d974da9c1e4f90c807f2cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c157b96149cfc77d83a067d51ceed5b912e84e7bbf97521b0600eb56b03bde"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit version").chomp
    system bin/"chkbit", "init", "split", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
