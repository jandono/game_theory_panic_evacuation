for i in {0..6}
do
for iteration in 30
do 
for children in 12
do
bsub -n 12 -W 2:00 -R "rusage[mem=1024]" matlab -nodisplay -singleCompThread -r "A_LearningAlgorithm($i,$iteration,$children)"
done
done
done

