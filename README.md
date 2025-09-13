# GitHub Classroom Tools

This repository is an index of tools created to assist instructors in managing courses in GitHub Classroom.

The tools included in this project are:
- [roster.jar](https://github.com/raul-izquierdo/roster): assists in maintaining the classroom roster as students join, leave, or change lab groups.
- [teams.jar](https://github.com/raul-izquierdo/teams): generates and updates GitHub Teams for each lab group based on the roster, enabling group-based permissions to repositories.
- [solutions.jar](https://github.com/raul-izquierdo/solutions): used to show or hide an assignment's solution for a lab group.

These tools are implemented in Java and require JDK 21 or later.

## Installation

To use these tools, download each tool’s JAR from its repository. Although manual download is possible, this repository includes download scripts (`get-jars.sh` or `get-jars.cmd`) that automate the process. Therefore, the recommended installation steps are:

1. Clone this repository:
   ```bash
   git clone https://github.com/raul-izquierdo/classroom-tools.git
   cd classroom-tools
   ```

2. Run the script for the appropriate operating system to download the tools' JARs.
   ```bash
   # Windows
   get-jars.cmd

   # Linux/Mac
   ./get-jars.shv
   ```

3. (Optional) Create a `.env` file with the organization name and the GitHub Classroom API access token.
    ```env
    GITHUB_ORG=<organization>
    GITHUB_TOKEN=<token>
    ```
    This step is optional. However, providing this file simplifies running the tools, as command-line flags will not be required. For information on obtaining the token, see [Obtaining the GitHub Token](#obtaining-the-github-token).

4. (Optional) Create the `schedule.csv` file with the schedules for the teacher groups. A template is included in the repository and contains sample groups that should be replaced with actual group data.
    ```csv
    01, monday, 21:00
    02, tuesday, 14:00, 3h
    i01, wednesday, 16:00, 45m
    ```
    This file is only necessary if automatic selection of solutions is to be used (see [Phase 4](#phase-4-at-the-end-of-each-assignment)), which is highly recommended. For more information on creating this file, refer to [schedule file format](https://github.com/raul-izquierdo/solutions/#schedule-file-format).


## Course Workflow

Although usage and options for each tool are explained in their respective repositories, this index presents the **intended workflow** and **when** to use each tool.
- [Phase 1. At the beginning of the course](#phase-1-at-the-beginning-of-the-course): Create the GitHub Classroom roster (the list of all students), which enables sending assignments.
- [Phase 2. After the first assignment](#phase-2-after-the-first-assignment): Generate GitHub Teams from the roster to grant repository access by group.
- [Phase 3. When a group changes](#phase-3-when-a-group-changes): Update the roster and Teams when enrollment or lab-group assignments change.
- [Phase 4. At the end of each assignment](#phase-4-at-the-end-of-each-assignment): Grant each group permission to view the assignment solution.
- [Phase 5. At the end of the course](#phase-5-at-the-end-of-the-course): Delete the roster and GitHub Classroom teams, leaving a clean organization for the next course (while keeping starter code and solutions).

> NOTE: In the examples below, it is assumed that the organization and GitHub token are defined in the `.env` file. If not, these must be provided on the command line to tools that require them using the `-o` and `-t` flags, respectively.


### Phase 1. At the beginning of the course

At the beginning of the course, the classroom roster must be created. This roster is the list of students who can receive assignments.

The following steps are required in this phase:

1. **Create a new classroom** (and optionally copy assignments from the previous one) using the GitHub Classroom web interface. No tool is required for this step.

2. Obtain the **list of students** enrolled in the course.

    The method for obtaining this list depends on the institution. At the University of Oviedo, this file is provided by the SIES academic management system. If that is not available, an Excel sheet or a simple TXT/CSV file such as the following may be used:

    ```csv
    "Izquierdo Castanedo, Raúl", grupo01
    "González, Juan", grupo_ingles_02
    "Alonso, Mariano", grupo01
    "Rodríguez, Javier", grupo02
    ```
    For more information, see the [student file formats](https://github.com/raul-izquierdo/roster#student-file-formats).

3. **Create the roster** from the student list using `roster.jar`.

    Before creating the roster, if the instructor does not teach all groups, it is useful to specify which groups he teaches to filter his students and ignore the rest. To indicate the instructor’s groups, create a `schedule.csv` file (if not already created in the installation process) and pass it using the `-g` option. The format of this file is explained in [groups file format](https://github.com/raul-izquierdo/roster#groups-file-format). The following examples will use this file.

    Examples of roster creation from different files formats:
    ```bash
    # Create a roster from SIES
    java -jar roster.jar create -g schedule.csv -f sies alumnosMatriculados.xls

    # Create a roster from a simple excel file with two columns
    java -jar roster.jar create -g schedule.csv -f excel myExcelFile.xls

    # Create a roster from a simple txt file.txt
    java -jar roster.jar create -g schedule.csv -f csv myTextFile.txt
    ```

    Example output:
    ```bash
    $ java -jar roster.jar create -g schedule.csv -f csv myTextFile

    ## Students to add to the roster

    Instructions:
    - Go to the Classroom page.
    - Click the 'Students' tab.
    - Click the 'Update Students' button.
    - Select and copy all the lines below at once, then paste them into the 'Create your roster manually' text area.

    Izquierdo Castanedo, Raúl (01)
    González Pérez, Juan (i02)
    Alonso, Mariano (01)
    Rodríguez, Javier (02)
    ```

    Each generated identifier includes the student’s lab group in parentheses, which facilitates filtering in the Classroom UI.

4. **Enter the roster manually**. GitHub Classroom does not offer an API to automate roster maintenance, so the result from the previous step must be copied and pasted into the web interface. `roster.jar` provides step-by-step instructions for this process.

After completing these steps, when creating repositories with assignment solutions, it is **recommended** to use a naming convention so that the `solutions.jar` tool can automatically deduce the solution corresponding to each class. For more information, see [Repository names for solutions](https://github.com/raul-izquierdo/solutions#repository-names-for-solutions).


### Phase 2. After the first assignment

To allow each group of students to view the solution to their assignment in phase 4, a separate GitHub Team must be created for each group. In this phase these teams will be created. But, unlike the roster, creation of these Teams is automated because GitHub provides an API for this task.

The steps in this phase are as follows:
1. Download an **updated** roster.
2. Create the Teams from the roster.

#### 2.1 Download an Updated roster

The roster was entered manually in phase 1; rather than regenerate it, download it from GitHub Classroom. To obtain this file, follow the instructions in [Obtaining the Roster File](#obtaining-the-roster-file).

**Important:** This step should be performed *after* students have accepted the first assignment; only then are their roster IDs associated with their GitHub accounts. Note the distinction between:
- The student’s **personal GitHub account/username**: This is the username the student uses to log in to GitHub. The tool `teams.jar` requires it to create the Teams, and it is not included in the roster until the first assignment is accepted.
- The student’s **roster identifier**: This is the identifier generated by `roster.jar` so the instructor can identify students in assignments without knowing their personal GitHub account.

If the roster is downloaded immediately after entry in phase 1, the GitHub username column (2) will be empty.
```csv
"identifier","github_username","github_id","name"
"i01-yaagma (i01)","","",""
"i02-cesar acebal (a02)","","",""
"i02-yaagma (i02)","","",""
```
If the roster is downloaded *after* students accept the first assignment, each student’s GitHub username will be included, which `teams.jar` requires.
```csv
"identifier","github_username","github_id","name"
"i01-yaagma (i01)","yaagma","40261856",""
"i02-cesar acebal (a02)","cesar24","40394857",""
"i02-yaagma (i02)","perez87","40261856",""
```

In practice, it is not necessary to wait for every student to associate a GitHub account (accept an assignment) to create Teams—some may never do so. It is sufficient to wait until the first assignment is completed and run this phase with the roster as is. Students without associated GitHub accounts will be ignored (and not added to Teams). If the roster is updated later, proceed to [phase 3 (roster and Teams update)](#phase-3-when-a-group-changes).

#### 2.2 Create the Teams

Once a roster that includes each student’s GitHub username is available, use the `teams.jar` tool to create the teams.

```bash
java -jar teams.jar <classroom_roster.csv>
```

The parameter is the roster CSV file. If omitted, the tool defaults to `classroom_roster.csv`.

This command may also be rerun with an updated roster to synchronize Teams: it adds new students, removes withdrawn ones, and moves students who have changed lab groups.

### Phase 3. When a group changes

During the course—especially in the first weeks—enrollments may change and students may switch lab groups. To keep the roster up to date, the following steps are required:

1. Obtain an updated list of students and their lab groups, using SIES or the institution’s information system.
2. [Obtain the roster file](#obtaining-the-roster-file).
3. **Determine the changes to make** in the roster by comparing the two files from steps 1 and 2 using `roster.jar`.

    For step 3, use `roster.jar` with the `update` command:
    ```bash
    java -jar roster.jar update -g schedule.csv -r classroom_roster.csv -f sies alumnosMatriculados.xls
    ```

    The output, unlike `create`, includes up to three sections (only those with changes will appear):
    - Students to add to the roster — newly enrolled students
    - Students to remove from the roster — students who have dropped out
    - Students who have changed groups — students who changed lab group

    Example output:
    ```bash
    $ java -jar roster.jar update -g schedule.csv -r classroom_roster.csv -f sies alumnosMatriculados.xls

    ## Students to add to the roster

    Instructions:
    - Go to the Classroom page.
    - Click the 'Students' tab.
    - Click the 'Update Students' button.
    - Select and copy all the lines below at once, then paste them into the 'Create your roster manually' text area.

    Izquierdo Castanedo, Raúl (01)
    González Pérez, Juan (i02)

    ## Students to remove from the roster

    Instructions:
    - Go to the Classroom page.
    - Click the 'Students' tab.
    - For each of the following lines:
        - Find the student with that roster ID and click the "trash" icon.

    Rodríguez Pérez, Mariano (01)
    Gómez Alonso, Antonio (i01)

    ## Students who have changed groups

    Instructions:
    - Go to the Classroom page.
    - Click the 'Students' tab.
    - For each of the following lines:
        - Find the student using the old roster ID (shown on the left side of the arrow) and click the "pen" icon.
        - Replace the old roster ID with the new one (shown on the right side of the arrow).

    González Pérez, Juan (02) ---> González Pérez, Juan (03)
    Valles Fuertes, Pedro (i01) ---> Valles Fuertes, Pedro (i02)
    Ramírez Barragán, Lucía (01) ---> Ramírez Barragán, Lucía (02)
    ```

    The output includes step-by-step instructions for performing each change (additions, removals, and moves).


4. **Manually** enter the changes obtained in step 3, following the instructions shown in the output of the `roster.jar` command.

5. To update the Teams, [obtain an updated roster](#obtaining-the-roster-file) again. **Important**: the copy from step 2 is **no longer valid** because the roster has been manually edited in step 4—a fresh copy must be downloaded.

6. **Update the Teams** with the same command used for their creation. This command will automatically detect the changes and recognize that it is an update rather than a creation.
    ```bash
    java -jar teams.jar <classroom_roster.csv>
    ```

### Phase 4. At the end of each assignment

After an assignment has been submitted and the solution has been explained, `solutions.jar` can be used to grant each group permission to access the repository containing the explained solution.

There are two ways to perform this task: manual selection and automatic selection (recommended).

#### Manual selection

To perform manual selection of the group and the solution, execute the following command:
```bash
java -jar solutions.jar
```

This command presents a menu for selecting the group and the solution to show or hide. Once this is done, students will have access to the specified repository.

#### Automatic selection

This is the recommended option, as the tool deduces the group and the solution to show, and in most cases, confirmation will be sufficient.
- The group is deduced from the current time, using the `schedule.csv` file created during installation.
- The solution to show is the first one for which the group does not yet have access.


> **IMPORTANT**: For automatic selection to work, the tool must be able to distinguish which repositories contain assignment solutions and which are regular repositories. This is achieved by following a naming convention: solution repositories must end with `solution` and, when sorted alphabetically, should appear in the same order as the assignments are given. For more details, see [Repository names for solutions](https://github.com/raul-izquierdo/solutions#repository-names-for-solutions).


Suppose the following `schedule.csv` file:
```csv
G1,wednesday 08:00
G2,tuesday 09:00
G-english-1,friday 10:00
```

In this case, the tool would be invoked as follows:
```bash
java -jar solutions.jar -s schedule.csv
```
The output would be:
```bash
$ java -jar solutions.jar -s schedule.csv
Connecting with Github... done.

(now: 'wednesday' 08:15) Proceed to show 'factorial-solution' to group 'G1'? (y/N): y
Access granted.
```

When ambiguity exists (no single scheduled group or none pending), the tool falls back to an interactive picker.

### Phase 5. At the end of the course

At the end of the course, the Teams for the finished course’s groups should be deleted. This revokes students’ access to solution repositories.

```bash
java -jar teams.jar --clean
```


## Access to Resources

### Obtaining the GitHub Token

A GitHub personal access token with the `repo` and `admin:org` scopes is required to manage teams and members. For instructions on how to create a token, see the [GitHub documentation: Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).

Once the token is available, it can be provided in three ways (in order of precedence):
1. In a `.env` file (recommended)
2. As a command-line argument: `-t <token>`
3. As an environment variable: `GITHUB_TOKEN`

### Obtaining the Roster File

The roster is the list of students that can receive assignments. Some of the tools described in this repository require this file to operate. The roster can be downloaded from the organization page.

The steps to obtain this file are:
1. Go to the GitHub Classroom page.
2. Click on the "Students" tab.
3. Click the "Download" button to obtain the CSV file `classroom_roster.csv`.


## License

See `LICENSE`.
Copyright (c) 2025 Raul Izquierdo Castanedo
