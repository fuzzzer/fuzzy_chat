enum VaultFailureType {
  // Auth failures
  incorrectMasterPassword,
  incorrectCustomPassword,
  weakPassword,
  vaultNotInitialized,
  vaultAlreadyExists,

  // CRUD failures
  itemNotFound,
  groupNotFound,
  duplicateItem,
  generalGroupUndeletable,

  // Storage failures
  storageReadError,
  storageWriteError,
  fileCorrupted,
  decryptionFailed,

  // Export/Import failures
  exportFailed,
  importFailed,
  invalidExportFile,
  exportPasswordIncorrect,

  // Directory failures
  directoryNotFound,
  directoryPermissionDenied,
  directoryReadError,

  // General
  unknown,
}
