# [Splitsh Lite](https://github.com/splitsh/lite) for Github Actions

A Github Action that allows you to split your monorepo into multiple repositories using [splitsh lite](https://github.com/splitsh/lite).

## Usage

1. Create a new file in your repository at `.github/workflows/split.yml`

2. Copy the following content into the `split.yml` file:

   ```yaml
   name: 'Split monorepo'
   
   on:
     push:
       branches:
         - master
         - '*.x'
       tags:
         - 'v*'

   jobs:
     split:
       runs-on: ubuntu-latest
   
       strategy:
         fail-fast: false
         matrix:
           package: [ 'package-one', 'package-two' ]
   
       steps:
         - name: Checkout code
           uses: actions/checkout@v3
           with:
             fetch-depth: 0
   
         - name: Split package ${{ matrix.package }}
           uses: "claudiodekker/splitsh-action@v1.0.0"
           env:
             GITHUB_TOKEN: ${{ secrets.MONOREPO_SPLITTER_PERSONAL_ACCESS_TOKEN }}
           with:
             prefix: "packages/${{ matrix.package }}"
             remote: "https://github.com/your-username/subsplit-of-${{ matrix.package }}.git"
             reference: "${{ github.ref_name }}"
             as_tag: "${{ startsWith(github.ref, 'refs/tags/') }}"
   ```

3. Modify the `matrix`'s `package` property to reflect your to-be-split packages (above: `package-one` and `package-two`).

4. Modify the `prefix` property to reflect the path to your package in your monorepo. In the above example, the packages are located in a `packages/` directory.

5. Modify the `remote` property to reflect the URL of the repository you want to split your package into. In the above example, the packages are split to `https://github.com/your-username/subsplit-of-package-one.git` and `https://github.com/your-username/subsplit-of-package-two.git`.

6. Add a `MONOREPO_SPLITTER_PERSONAL_ACCESS_TOKEN` to your repository's secrets. This is a personal access token with the `repo` scope, and is used to push the split repository to GitHub. You can create a new token [here](https://github.com/settings/tokens/new). 
   If your monorepo's package directory contains a `.github/workflows/` folder, you'll likely need to add the `workflow` scope to the token as well, as otherwise the splitter cannot push the changes to your repository.

7. Commit and push the file to your (monorepo) repository.

Once done, the  GitHub Action will automatically split your monorepo into the target repositories when a commit is added to the provided branches (in the above example, `master`, `1.x`, `2.x` etc.), or when a new tag (e.g. `v1.0.0`) is added to the repository.
