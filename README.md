# NextFlow
A Nextflow workflow which trims sequences and assembles them.

1. The environment can be replicated using the environment.yml file to install the dependencies needed to execute the workflow. Create a conda environment using the YML file.
```sh
conda env create -f environment.yml
```

2. Activate the created nexenv conda environment
```sh
conda activate nexenv
```

3. You should have Nextflow installed on your local system (You will need Java 8 or later installed for it)
```sh
curl -s https://get.nextflow.io | bash
```

4. After configuring the Nextflow installation, you can run the script using this command-
```sh
nextflow run main.nf
```

5. You'll find two folders created within a new folder 'results'. The 'cleaned_reads' folder will contain the trimmed sequences while the 'assembly' folder will contain the SPAdes assembly for the given sequences.



## Trimming

### Inputs:

sample_id: Sample identifier.  
read1: Path to the first read file.  
read2: Path to the second read file.  

### Outputs:

Two trimmed read files

## Assembly

### Inputs:

sample_id: Sample identifier.  
clean_r1: Path to the trimmed first read file.  
clean_r2: Path to the trimmed second read file.  

### Outputs:

Assembled genome fasta file


