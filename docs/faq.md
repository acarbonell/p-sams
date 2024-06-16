# Frequently Asked Questions

## Questions
[How does P-SAMS work?](#q-how-does-p-sams-work)

[How do I cite P-SAMS?](#q-how-do-i-cite-p-sams)

[Where can I download the cloning methods?](#q-where-can-i-download-the-cloning-methods)

[What are B/c vectors?](#q-what-are-bc-vectors)

[Where do I order B/c vectors compatible with P-SAMS oligonucleotides?](#q-where-do-i-order-bc-vectors-compatible-with-p-sams-oligonucleotides)

[Are P-SAMS oligonucleotides compatible with other amiRNA cloning vectors?](#q-are-p-sams-oligonucleotides-compatible-with-other-amirna-cloning-vectors)

[What B/c vectors are compatible with my species?](#q-what-bc-vectors-are-compatible-with-my-species)

[What if I need to clone my artificial miRNA or synthetic tasiRNA into a vector with an alternative promoter or selectable marker absent in available B/c vectors?](#q-what-if-i-need-to-clone-my-artificial-mirna-or-synthetic-tasirna-into-a-vector-with-an-alternative-promoter-or-selectable-marker-absent-in-available-bc-vectors)

[Should I design an artificial miRNA or several synthetic tasiRNAs?](#q-should-i-design-an-artificial-mirna-or-several-synthetic-tasirnas)

[I already have amiRNA/syn-tasiRNA sequence(s) that I want to use, can I just get the sequences of the two oligonucleotides I need for cloning into the appropriate B/c vector?](#q-i-already-have-amirnasyn-tasirna-sequences-that-i-want-to-use-can-i-just-get-the-sequences-of-the-two-oligonucleotides-i-need-for-cloning-into-the-appropriate-bc-vector)

[What is the difference between Optimal results and Suboptimal results?](#q-what-is-the-difference-between-optimal-results-and-suboptimal-results)

[When designing an artificial microRNA with P-SAMS amiRNA Designer, what should I do if I do not get results?](#q-when-designing-an-artificial-microrna-with-p-sams-amirna-designer-what-should-i-do-if-i-do-not-get-results)

[How many synthetic tasiRNA can I multiplex into one construct?](#q-how-many-synthetic-tasirnas-can-i-multiplex-in-the-same-construct)

## Answers

### Q: How does P-SAMS work?
A: The P-SAMS process is virtually the same whether designing an artificial microRNA (amiRNA) or a synthetic trans-acting
short-interfering RNA (syn-tasiRNA) to target one or more genes of interest. P-SAMS first identifies all possible target
sites by cataloging the complete set of 21-nucleotide sequences from all input transcripts, including isoforms (foreground
set). If off-target filtering is enabled, the foreground target site set is filtered to remove sites that contain a
15-nucleotide sequence from positions 6–20 (core target pairing sequence) that perfectly match a transcript that is not
contained in the input set (background set). The remaining sites are grouped by the core target pairing sequence, and only
site groups that contain all input genes are considered further. Grouped sites are scored and ranked based on group-wise
similarity and the identify of nucleotides at specific positions (positions 1, 2, 3 and 21). For each group of sites, a guide
RNA (amiRNA or syn-tasiRNA) is designed to target all sites with the additional criteria that i) the guide RNA has a 5’U
nucleotide, ii) position 19 of the guide is a C (so that the guide RNA* has a 5’G), and iii) position 21 is intentionally
mismatched. Finally, P-SAMS uses TargetFinder to predict target RNAs for each guide, and guide RNAs that are only predicted to
target transcripts from input genes are output as optimal results. Currently only up to three optimal results are returned due
to the relatively long runtime requirements of TargetFinder.

### Q: How do I cite P-SAMS?
A: If using P-SAMS please cite:

Fahlgren, N, Hill ST, Carrington JC, Carbonell A (2016) P-SAMS: a web site for plant artificial microRNA and synthetic
trans-acting small interfering RNA design. *Bioinformatics* 32: 157-158. doi:
[10.1093/bioinformatics/btv534](https://doi.org/10.1093/bioinformatics/btv534).

If using AtMIR390a- or AtTAS1c-based B/c vectors please cite:

Carbonell A, Takeda A, Fahlgren N, Johnson SC, Cuperus JT, Carrington JC (2014) New generation of artificial microRNA and
synthetic trans-acting small interfering RNA vectors for efficient gene silencing in Arabidopsis. *Plant Physiology* 165:
15–29. doi: [10.1104/pp.113.234989](https://doi.org/10.1104/pp.113.234989).

If using OsMIR390-based B/c vectors please cite:

Carbonell A., Fahlgren N, Mitchell S, Cox Jr KL, Reilly KC, Mockler TC, Carrington JC (2015) Highly specific gene silencing
in a monocot species by artificial microRNAs derived from chimeric MIRNA precursors. *The Plant Journal* 82: 1061-1075. doi:
[10.1111/tpj.12835](https://doi.org/10.1111/tpj.12835).

### Q: Where can I download the cloning methods?
A: The cloning protocol is available [here](../assests/Cloning_protocol.pdf).

### Q: What are B/c vectors?
A: BsaI-ccdB ('B/c') vectors are used for direct cloning of artificial microRNA (amiRNA) or synthetic trans-acting
short-interfering RNA (syn-tasiRNA). The majority of B/c vectors are plant expression vectors with a unique combination of
promoter and terminator sequences for expressing amiRNA or syn-tasiRNA, and bacterial and plant antibiotic resistance genes.
We also developed a subset of GATEWAY-compatible entry B/c vectors to clone the amiRNA or syn-tasiRNA insert and subsequently
recombine it into the preferred GATEWAY expression vector containing a promoter, terminator or other features of choice. B/c
vectors contain a modified version of an amiRNA or syn-tasiRNA precursor sequence that includes a ccdB cassette flanked by two
BsaI sites. AmiRNA or syn-tasiRNA inserts resulting from the annealing of two overlapping and partially complementary
oligonucleotides are ligated directionally into a zero background B/c vector. P-SAMS amiRNA Designer and P-SAMS syn-tasiRNA
Designer output the sequence of the two oligonucleotides needed to generate the amiRNA or syn-tasiRNA insert, respectively.
B/c amiRNA vectors for eudicots and monocots contain the *Arabidopsis thaliana MIR390a* or *Oryza sativa MIR390* precursor
sequence, respectively. B/c syn-tasiRNA vectors contain the *Arabidopsis thaliana TAS1c* precursor sequence.

### Q: Where do I order B/c vectors compatible with P-SAMS oligonucleotides?
A: The following amiRNA and syn-tasiRNA B/c vectors are available from [Addgene](http://www.addgene.org/):
*pENTR-AtMIR390a-B/c* ([Addgene plasmid 51778](https://www.addgene.org/51778/)),
*pMDC32B-AtMIR390a-B/c* ([Addgene plasmid 51776](https://www.addgene.org/51776/)),
*pMDC123SB-AtMIR390a-B/c* ([Addgene plasmid 51775](https://www.addgene.org/51775/)),
*pFK210B-AtMIR390a-B/c* ([Addgene plasmid 51777](https://www.addgene.org/51777/)),
*pENTR-AtTAS1c-B/c* ([Addgene plasmid 51774](https://www.addgene.org/51774/)),
*pMDC32B-AtTAS1c-B/c* ([Addgene plasmid 51773](https://www.addgene.org/51773/)),
*pMDC123SB-AtTAS1c-B/c* ([Addgene plasmid 51772](https://www.addgene.org/51772/)),
*pENTR-OsMIR390-B/c* ([Addgene plasmid 61468](https://www.addgene.org/61468/)),
*pMDC32B-OsMIR390-B/c* ([Addgene plasmid 61467](https://www.addgene.org/61467/)),
*pMDC123SB-OsMIR390-B/c* ([Addgene plasmid 61466](https://www.addgene.org/61466/)), and
*pH7WG2B-OsMIR390-B/c* ([Addgene plasmid 61465](https://www.addgene.org/61465/)).

### Q: Are P-SAMS oligonucleotides compatible with other amiRNA cloning vectors?
A: No. P-SAMS oligonucleotides are only compatible with [B/c vectors](#q-what-bc-vectors-are-compatible-with-my-species).
If you want to clone your artificial miRNA or synthetic tasiRNA into a different vector system, you can still use P-SAMS
amiRNA Designer and P-SAMS syn-tasiRNA Designer apps to design the artificial miRNA or synthetic tasiRNA sequences,
respectively.

### Q: What B/c vectors are compatible with my species?
A: Check the following tables to determine the species compatibility of each B/c vector.

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-1wig{font-weight:bold;text-align:left;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
.tg .tg-8zwo{font-style:italic;text-align:left;vertical-align:top}
</style>
<table class="tg"><thead>
  <tr>
    <th class="tg-0lax" colspan="9"><span style="font-weight:bold">Eudicot amiRNA vectors</span>: <span style="font-style:italic">BsaI/ccdB</span>-based ('B/c') vectors for direct cloning of amiRNAs to use in eudicot species.<br><span style="font-weight:200;font-style:italic">CaMV</span><span style="font-style:italic">, Cauliflower mosaic virus; nos, nopaline synthase; rbcS, Rubisco small subunit.</span></th>
  </tr></thead>
<tbody>
  <tr>
    <td class="tg-1wig">Vector</td>
    <td class="tg-1wig">Bacterial antibiotic resistance</td>
    <td class="tg-1wig">Plant antibiotic resistance</td>
    <td class="tg-1wig">GATEWAY use</td>
    <td class="tg-1wig">Promoter</td>
    <td class="tg-1wig">Terminator</td>
    <td class="tg-1wig">Plant species tested</td>
    <td class="tg-1wig">Addgene number and link</td>
    <td class="tg-1wig">Plasmid sequence</td>
  </tr>
  <tr>
    <td class="tg-8zwo">pENTR-AtMIR390a-B/c</td>
    <td class="tg-0lax">Kanamycin</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">Donor</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51778/" target="_blank" rel="noopener noreferrer">51778</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pENTR_AtMIR390aBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pENTR_AtMIR390aBc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo">pFK210B-AtMIR390a-B/c</td>
    <td class="tg-0lax">Spectinomycin</td>
    <td class="tg-0lax">BASTA</td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo">CaMV 35S</td>
    <td class="tg-8zwo">rbcS</td>
    <td class="tg-8zwo">A. thaliana</td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51777/" target="_blank" rel="noopener noreferrer"><span style="font-weight:400;font-style:normal;text-decoration:none">51777</span></a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pFK210B_AtMIR390aBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pFK210B_AtMIR390aBc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo">pMDC123SB-AtMIR390a-B/c</td>
    <td class="tg-0lax">Kanamycin</td>
    <td class="tg-0lax">BASTA</td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo">CaMV 2x35S</td>
    <td class="tg-8zwo">nos</td>
    <td class="tg-8zwo">A. thaliana<br>N. benthamiana</td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51775/" target="_blank" rel="noopener noreferrer">51775</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pMDC123SB_AtMIR390aBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pMDC123SB_AtMIR390aBc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo">pMDC32B-AtMIR390a-B/c</td>
    <td class="tg-0lax">Kanamycin<br><span style="font-weight:200;font-style:normal">Hygromycin</span></td>
    <td class="tg-0lax">Hygromycin</td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo">CaMV 2x35S</td>
    <td class="tg-8zwo">nos</td>
    <td class="tg-8zwo">A. thaliana<br>N. benthamiana</td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51776/" target="_blank" rel="noopener noreferrer">51776</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pMDC32B_AtMIR390aBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pMDC32B_AtMIR390aBc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
</tbody></table>

<br/>

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-1wig{font-weight:bold;text-align:left;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
.tg .tg-8zwo{font-style:italic;text-align:left;vertical-align:top}
</style>
<table class="tg"><thead>
  <tr>
    <th class="tg-0lax" colspan="9"><span style="font-weight:bold">Monocot amiRNA vectors</span>: <span style="font-style:italic">OsMIR390-BsaI/ccdB</span> ('B/c') vectors for direct cloning of amiRNAs to use in monocot species.<br><span style="font-weight:200;font-style:italic">CaMV</span><span style="font-style:italic">, Cauliflower mosaic virus; nos, nopaline synthase; Os, Oryza sativa.</span></th>
  </tr></thead>
<tbody>
  <tr>
    <td class="tg-1wig">Vector</td>
    <td class="tg-1wig">Bacterial antibiotic resistance</td>
    <td class="tg-1wig">Plant antibiotic resistance</td>
    <td class="tg-1wig">GATEWAY use</td>
    <td class="tg-1wig">Promoter</td>
    <td class="tg-1wig">Terminator</td>
    <td class="tg-1wig">Plant species tested</td>
    <td class="tg-1wig">Addgene number and link</td>
    <td class="tg-1wig">Plasmid sequence</td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pENTR-OsMIR390-B/c</span></td>
    <td class="tg-0lax">Kanamycin</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">Donor</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax"><a href="https://www.addgene.org/61468/" target="_blank" rel="noopener noreferrer">61468</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pENTR_OsMIR390Bc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pENTR_OsMIR390Bc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pMDC123SB-OsMIR390-B/c</span></td>
    <td class="tg-0lax">Kanamycin</td>
    <td class="tg-0lax">BASTA</td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo"><span style="font-weight:400;font-style:italic">CaMV 2x35S</span></td>
    <td class="tg-8zwo">nos</td>
    <td class="tg-8zwo"><span style="font-weight:200">N. benthamiana</span></td>
    <td class="tg-0lax"><a href="https://www.addgene.org/61466/" target="_blank" rel="noopener noreferrer">61466</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pMDC123SB_OsMIR390Bc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pMDC123SB_OsMIR390Bc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pMDC32B-OsMIR390-B/c</span></td>
    <td class="tg-0lax">Kanamycin<br>Hygromycin</td>
    <td class="tg-0lax"><span style="font-weight:200;font-style:normal">Hygromycin</span></td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo">CaMV 2x35S</td>
    <td class="tg-8zwo">nos</td>
    <td class="tg-8zwo"><span style="font-weight:200">N. benthamiana</span><br><span style="font-weight:200">B. distachyon</span></td>
    <td class="tg-0lax"><a href="https://www.addgene.org/61467/" target="_blank" rel="noopener noreferrer">61467</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pMDC32B_OsMIR390Bc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pMDC32B_OsMIR390Bc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pH7WG2B-OsMIR390-B/c</span></td>
    <td class="tg-0lax">Spectinomycin</td>
    <td class="tg-0lax">Hygromycin</td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo">Os Ubiquitin</td>
    <td class="tg-8zwo">CaMV</td>
    <td class="tg-8zwo"><span style="font-weight:200">B. distachyon</span></td>
    <td class="tg-0lax"><a href="https://www.addgene.org/61465/" target="_blank" rel="noopener noreferrer">61465</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pH7WG2B_OsMIR390Bc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pH7WG2B_OsMIR390Bc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
</tbody></table>

<br/>

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-1wig{font-weight:bold;text-align:left;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
.tg .tg-8zwo{font-style:italic;text-align:left;vertical-align:top}
</style>
<table class="tg"><thead>
  <tr>
    <th class="tg-0lax" colspan="9"><span style="font-weight:bold">syn-tasiRNA vectors</span>: <span style="font-style:italic">OsMIR390-BsaI/ccdB</span> ('B/c') vectors for direct cloning of syn-tasiRNAs to use in <span style="font-style:italic">Arabidopsis thaliana</span> and closely related species*.<br><span style="font-weight:200;font-style:italic">CaMV</span><span style="font-style:italic">, Cauliflower mosaic virus; nos, nopaline synthase.</span></th>
  </tr></thead>
<tbody>
  <tr>
    <td class="tg-1wig">Vector</td>
    <td class="tg-1wig">Bacterial antibiotic resistance</td>
    <td class="tg-1wig">Plant antibiotic resistance</td>
    <td class="tg-1wig">GATEWAY use</td>
    <td class="tg-1wig">Promoter</td>
    <td class="tg-1wig">Terminator</td>
    <td class="tg-1wig">Plant species tested</td>
    <td class="tg-1wig">Addgene number and link</td>
    <td class="tg-1wig">Plasmid sequence</td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pENTR-AtTAS1c-B/c</span></td>
    <td class="tg-0lax">Kanamycin</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">Donor</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax">-</td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51774/" target="_blank" rel="noopener noreferrer">51774</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pENTR_AtTAS1cBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pENTR_AtTAS1cBc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pMDC123SB-AtTAS1c-B/c</span></td>
    <td class="tg-0lax">Kanamycin</td>
    <td class="tg-0lax">BASTA</td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo"><span style="font-weight:400;font-style:italic">CaMV 2x35S</span></td>
    <td class="tg-8zwo">nos</td>
    <td class="tg-8zwo"><span style="font-weight:200">A. thaliana</span><br><span style="font-weight:200">N. benthamiana*</span></td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51772/" target="_blank" rel="noopener noreferrer">51772</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pMDC123SB_AtTAS1cBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pMDC32B_AtTAS1cBc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo"><span style="font-weight:200">pMDC32B-AtTAS1c-B/c</span></td>
    <td class="tg-0lax">Kanamycin<br>Hygromycin</td>
    <td class="tg-0lax"><span style="font-weight:200;font-style:normal">Hygromycin</span></td>
    <td class="tg-0lax">-</td>
    <td class="tg-8zwo">CaMV 2x35S</td>
    <td class="tg-8zwo">nos</td>
    <td class="tg-8zwo"><span style="font-weight:200">A. thaliana</span><br><span style="font-weight:200">N. benthamiana*</span></td>
    <td class="tg-0lax"><a href="https://www.addgene.org/51773/" target="_blank" rel="noopener noreferrer">51773</a></td>
    <td class="tg-0lax"><a href="https://p-sams.carringtonlab.org/assets/fasta_pMDC32B_AtTAS1cBc.docx" target="_blank" rel="noopener noreferrer">FASTA</a><br><a href="https://p-sams.carringtonlab.org/assets/pMDC32B_OsMIR390Bc.gb" target="_blank" rel="noopener noreferrer">GenBank</a></td>
  </tr>
  <tr>
    <td class="tg-8zwo" colspan="9">*miR173-guided cleavage is required to trigger tasiRNA biogenesis but is only conserved in species closely related to A. thaliana. A construct expressing miR173 has to be co-expressed with the syn-tasiRNA construct to trigger syn-tasiRNA biogenesis in species that lack miR173.</td>
  </tr>
</tbody></table>

### Q: What if I need to clone my artificial miRNA or synthetic tasiRNA into a vector with an alternative promoter or selectable marker absent in available B/c vectors?
A: If your expression vector is GATEWAY-compatible, you can use *pENTR-AtMIR390a-B/c* and *pENTR-OsMIR390* for cloning
artificial miRNA to use in eudicots and monocots, respectively, and *pENTR-AtTAS1c-B/c* for cloning synthetic tasiRNA to use
in *Arabidopsis thaliana* and close related species (e.g. *Camelina sativa*). If you want to clone your artificial miRNA or
synthetic tasiRNA into a totally different vector system, you can still use P-SAMS amiRNA Designer or P-SAMS syn-tasiRNA
Designer apps to design the artificial miRNA(s) or synthetic tasiRNA(s), respectively, and disregard the information related
to the two oligonucleotides compatible with B/c vectors.

### Q: Should I design an artificial miRNA or several synthetic tasiRNAs?
A: An artificial miRNA is the preferred option to target a single gene. Artificial miRNA can also be designed to target
multiple genes if these share enough sequence similarity. P-SAMS amiRNA Designer outputs the sequence of the two
oligonucleotides needed to clone the designed amiRNA into the preferred B/c vector. B/c vectors containing the
*Arabidopsis thaliana MIR390a* or the *Oryza sativa MIR390* foldbacks are for use in eudicot or monocots species, respectively.

In *Arabidopsis thaliana* and other close related species that express miR173 (e.g. *Camelina sativa*), syn-tasiRNAs can be
used to target multiple unrelated genes. For other plant species, co-expression of miR173 together with the syn-tasiRNA
construct is necessary to produce syn-tasiRNAs. Several syn-tasiRNAs can be multiplexed in the same construct, with each
individual syn-tasiRNA targeting a specific gene or sets of genes. We have successfully tested multiplexing up to two
syn-tasiRNAs, but theoretically, more than two syn-tasiRNAs can be multiplexed in the same construct. P-SAMS syn-tasiRNA
Designer outputs the sequence of the two oligonucleotides needed to clone the syn-tasiRNA into the preferred B/c vector
containing the *Arabidopsis thaliana TAS1c* precursor.

### Q: I already have amiRNA/syn-tasiRNA sequence(s) that I want to use, can I just get the sequences of the two oligonucleotides I need for cloning into the appropriate B/c vector?
A: Yes, for artificial microRNA (amiRNA), use the `amiRNA_oligoDesigner.pl` tool and for synthetic trans-acting
short-interfering RNA (syn-tasiRNA), use the `syntasiRNA_oligoDesigner.pl` tool. Both tools are available on
[GitHub](https://github.com/carringtonlab/p-sams).

### Q: What is the difference between Optimal results and Suboptimal results?
A: The P-SAMS amiRNA Designer and P-SAMS syn-tasiRNA Designer apps output the results in two categories: the Optimal results
and the Suboptimal results. The Optimal results category includes designed artificial miRNA(s) or synthetic tasiRNA(s) that
target specifically the desired target gene(s). The Suboptimal results category includes artificial miRNA(s) or synthetic
tasiRNA(s) that follow the design parameters but that do not target specifically the desired target gene as they have have at
least one off-target. An off-target is a gene different than the desired target gene that is predicted to be potentially
targeted by the designed suboptimal artificial miRNA.

### Q: When designing an artificial microRNA with P-SAMS amiRNA Designer, what should I do if I do not get results?
A: P-SAMS amiRNA Designer will design artificial miRNA(s) that target single genes in most cases. However, when multiple genes
need to be targeted simultaneously, P-SAMS amiRNA Designer may not always display results. This is usually due to a limited
sequence homology between the selected target genes, or to the presence of off-targets [transcripts with high sequence
homology with the desired target transcript(s)] that difficult P-SAMS to design a specific artificial miRNA.

When P-SAMS amiRNA Designer fails to design an artificial miRNA that targets multiple unrelated genes, synthetic tasiRNAs may
be a good alternative to use in *Arabidopsis thaliana* or in other close related species that express the miR173 trigger
(e.g. *Camelina sativa*). Note that for other plant species, co-expression of miR173 together with the synthetic tasiRNA
construct is necessary to produce synthetic tasiRNAs. Group your target genes in different groups based on their sequence
homology, and have P-SAMS design a syn-tasiRNA for targeting each group of genes. We have successfully tested multiplexing up
to two synthetic tasiRNAs (for e.g. for two groups of target genes or two single unrelated genes), but, theoretically, more
than two synthetic tasiRNAs could be multiplexed in the same construct.

### Q: How many synthetic tasiRNAs can I multiplex in the same construct?
A: We have successfully tested multiplexing up to two syn-tasiRNA in a single construct. But in theory, more than two
syn-tasiRNA could be multiplexed. However, it is known that the farther from the miR173 target site the syn-tasiRNA is cloned,
the lowest it accumulates in vivo, suggesting that syn-tasiRNAs located too far away from miR173 target site may be very
poorly expressed and, consequently, inactive. This may actually limit the total number of effective syn-tasiRNA that can be
multiplexed in a single construct. We decided to limit to four the number of syn-tasiRNAs that can be multiplexed in a single
construct using P-SAMS syn-tasiRNA Designer.
