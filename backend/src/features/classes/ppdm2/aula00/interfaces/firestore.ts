export interface IFirestoreValue {
  stringValue?: string;
  integerValue?: string;
}

export interface IFirestoreDocument {
  name?: string;
  fields?: Record<string, IFirestoreValue>;
}
