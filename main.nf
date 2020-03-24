Channel
  .fromPath(params.sraIDs)
  .ifEmpty { exit 1, "SRA IDs file not found: ${params.sraIDs}" }
  .splitText()
  .map { it -> it.trim() }
  .set { singleSRAId }

params.resultdir = 'results'

process getAccession {
	tag "${sraID}"
	publishDir params.resultdir, mode: 'copy'
	
	input:
	val sraID from singleSRAId
	
	output:
	set val(sraID), file("*.fastq.gz") into readFiles

	script:
	"""
	fasterq-dump $sraID --threads ${task.cpus} --split-3
	pigz *.fastq
	"""
}
