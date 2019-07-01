for Nit in 10 20 30
do
for N_children in 12
do
bsub -n 4 -W 4:00 -R "rusage[mem=2048]" matlab -nodisplay -singleCompThread -r "pixel_LearningAlgorithm($Nit,$N_children)"
done
done
