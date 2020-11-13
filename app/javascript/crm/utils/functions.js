export default {
  arrDiffs(a, b) {
    return a.filter(x => !b.includes(x));
  },
  arrFilterById(array, id) {
    return array.filter(function( object ) {
      return object.id !== id;
    });
  },
  resetEntity(entity) {
    for (let key in entity) {
      entity[key] = '';
    }
  }
}