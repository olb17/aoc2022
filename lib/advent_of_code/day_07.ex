defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> parse_tree()
    |> compute_size("/")
    |> Map.filter(fn {_k, v} -> v.size <= 100_000 end)
    |> Enum.reduce(0, fn {_, dir}, acc -> dir.size + acc end)
  end

  def parse_tree(lines) do
    Enum.reduce(
      lines,
      {%{"/" => %{name: "/", parent: nil, size: 0, dirs: [], files: []}}, "/"},
      fn
        "$ cd /", {repo, "/"} ->
          {repo, "/"}

        "$ cd ..", {repo, curr_dir} ->
          {repo, repo[curr_dir].parent}

        "$ cd " <> dir_name, {repo, curr_dir} ->
          path = "#{repo[curr_dir].name}/#{dir_name}"

          if Map.has_key?(repo, path) do
            {repo, path}
          else
            new_dir = %{name: path, parent: repo[curr_dir].name, size: 0, dirs: [], files: []}
            {Map.put(repo, path, new_dir), path}
          end

        "$ ls", {repo, curr_dir} ->
          {repo, curr_dir}

        "dir " <> dir_name, {repo, curr_dir} ->
          new_path = "#{repo[curr_dir].name}/#{dir_name}"
          new_dir = %{repo[curr_dir] | dirs: [new_path | repo[curr_dir].dirs]}
          {%{repo | curr_dir => new_dir}, curr_dir}

        line, {repo, curr_dir} ->
          [file_size, file_name] = String.split(line, " ")

          new_dir = %{
            repo[curr_dir]
            | files: [{String.to_integer(file_size), file_name} | repo[curr_dir].files]
          }

          {%{repo | curr_dir => new_dir}, curr_dir}
      end
    )
    |> elem(0)
  end

  def compute_size(repo, curr_dir) do
    file_size = repo[curr_dir].files |> Enum.map(&elem(&1, 0)) |> Enum.sum()

    {repo, dir_size} =
      Enum.reduce(repo[curr_dir].dirs, {repo, 0}, fn dir, {repo, size} ->
        repo = compute_size(repo, dir)
        {repo, size + repo[dir].size}
      end)

    new_dir = %{repo[curr_dir] | size: dir_size + file_size}

    %{repo | curr_dir => new_dir}
  end

  def part2(args) do
    repo =
      args
      |> String.split("\n", trim: true)
      |> parse_tree()
      |> compute_size("/")

    required_size = 30_000_000 - 70_000_000 + repo["/"].size

    repo
    |> Map.filter(fn {_k, v} -> v.size > required_size end)
    |> Map.values()
    |> Enum.sort(&(&1.size < &2.size))
    |> hd()
    |> Map.get(:size)
  end
end
