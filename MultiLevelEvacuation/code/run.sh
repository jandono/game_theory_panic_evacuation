for i in {0..6}
do
for iteration in 16
do 
for children in 12
do
bsub -n 12 -W 1:00 -R "rusage[mem=512]" matlab -nodisplay -singleCompThread -r "A_LearningAlgorithm($i,$iteration,$children)"
done
done
done

