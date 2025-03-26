class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.5.2.tgz"
  sha256 "df0996d08c18bb3d99f9405110bb42a4fda213793c924462be282b229ba92d57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f4c6e670cb00b0a54a140757c25b6f3574bb57b913db5410b4233f92f801f1e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sql-formatter --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM users WHERE id = 1;
    SQL

    system bin/"sql-formatter", "--fix", "test.sql"
    expected_output = <<~SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = 1;
    SQL

    assert_equal expected_output, (testpath/"test.sql").read
  end
end
