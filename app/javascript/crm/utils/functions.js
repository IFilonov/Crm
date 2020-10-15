export default {
  arrDiffs(a, b) {
    return a.filter(x => !b.includes(x));
  },
  resetEntity(entity) {
      for (let key in entity) {
          entity[key] = '';
      }
  }
}