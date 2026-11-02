import '../models/template.dart';

const List<Template> defaultTemplates = [
  Template(
    id: 'template_upper',
    name: 'UPPER',
    days: ['SUN', 'WED'],
    routineExercises: [
      TemplateExercise(name: 'Treadmill walk', target: '5 min', load: '-'),
      TemplateExercise(name: 'Arm circles', target: '10 each way', load: 'Body'),
      TemplateExercise(name: 'Wrist circles', target: '10 each way', load: 'Body'),
      TemplateExercise(name: 'Lat pulldown', target: '2 x 12', load: '25-30 kg'),
      TemplateExercise(name: 'Push-up', target: '2 x 10', load: 'Body'),
      TemplateExercise(name: 'Dumbbell press', target: '2 x 12', load: '6-8 kg each'),
      TemplateExercise(name: 'Arm curl', target: '2 x 12', load: '5-6 kg each'),
      TemplateExercise(name: 'Triceps pushdown', target: '2 x 12', load: '10-15 kg'),
      TemplateExercise(name: 'Wrist curl', target: '2 x 15', load: '3-4 kg each'),
      TemplateExercise(name: 'Reverse wrist curl', target: '2 x 15', load: '2-3 kg each'),
      TemplateExercise(name: 'Treadmill', target: '10 min', load: '-'),
      TemplateExercise(name: 'Cycling', target: '5 min', load: '-'),
    ],
  ),
  Template(
    id: 'template_lower',
    name: 'LOWER',
    days: ['MON', 'THU'],
    routineExercises: [
      TemplateExercise(name: 'Treadmill walk', target: '5 min', load: '-'),
      TemplateExercise(name: 'Leg swings', target: '10 each leg', load: 'Body'),
      TemplateExercise(name: 'Bodyweight squats', target: '1 x 10', load: 'Body'),
      TemplateExercise(name: 'Leg press / squats', target: '2 x 12', load: '30-40 kg'),
      TemplateExercise(name: 'Leg extension', target: '2 x 12', load: '15-20 kg'),
      TemplateExercise(name: 'Leg side raise', target: '2 x 12', load: 'Body'),
      TemplateExercise(name: 'Calf raise', target: '2 x 15', load: 'Body'),
      TemplateExercise(name: 'Crunches', target: '2 x 15', load: 'Body'),
      TemplateExercise(name: 'Plank', target: '2 x 30 sec', load: 'Body'),
      TemplateExercise(name: 'Treadmill', target: '10 min', load: '-'),
      TemplateExercise(name: 'Cycling', target: '5 min', load: '-'),
    ],
  ),
];
