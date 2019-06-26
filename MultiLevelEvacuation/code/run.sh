for i in {0..6}
do
bsub -n 12 -W 1:00 -R "rusage[mem=512]" matlab -nodisplay -singleCompThread -r "pixel_LearningAlgorithm($i,16,12)"
done

