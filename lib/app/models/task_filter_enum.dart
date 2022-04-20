enum TaskfilterEnum {
  today,
  tomorrow,
  week,
}

extension TaskFilterDescription on TaskfilterEnum {
  String get description {
    switch (this) {
      case TaskfilterEnum.today:
        return 'DE HOJE';
      case TaskfilterEnum.tomorrow:
        return 'DE AMANHA';
      case TaskfilterEnum.week:
        return 'DA SEMANA';
    }
  }
}
