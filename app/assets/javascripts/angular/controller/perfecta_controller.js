function customPointerInterval(selected) {
  switch (selected) {
    case 'day':
      return 24 * 3600 * 1000;
      break;
    case 'hour':
      return 3600 * 1000;
      break;
    default:
      return 24 * 3600 * 1000;
      break;
  }
}
