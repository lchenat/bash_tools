# bash_tools

My bash tools for a more convenient life.

### To
**To** can help you create a list of your favorite directories you frequently visit, and provide fast access to them.

#### Create a new link to you favorite directory
The following command helps you create a link to a directory with a specified link name.
```shell
to -c name path_of_directory
```

If you want to create a link with the name same as the directory's name, use the following command:
```shell
to -c path_of_directory
```

If you want to create a link to current directory with the name same as the directory's name, simple do this:
```shell
to .
```

#### Access a directory
Simple type **to** and press **[Tab]**, a list of the recorded directories will be shown:
```shell
to [Tab]
dir1  dir2  dir2
```

You can even access other files using relative path, and tab completion will also work correctly in this case.
```shell
to dir1/../another_dir/
file_1_in_another_dir file2_in_another_dir
```
#### Other commands
List all links:
```shell
to -l
```

Delete a link:
```shell
to -d name_of_the_link
```

#### Path substitutions
You can also use these links when executing other commands by the command **tt**, an argument starts with ~ will be expanded according to the link.
```shell
tt python ~my_link/hi.py
```
