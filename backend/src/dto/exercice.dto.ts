import { ExerciseDifficulty } from "../enum/exercice-difficulty.enum";
import { ExerciseEquipment } from "../enum/exercice-equipment.enum";

export interface UpdateExercice {
    id: string;
    name?: string;
    description?: string;
    difficulty?: ExerciseDifficulty;
    is_compound?: boolean;
    equipment?: ExerciseEquipment;
}