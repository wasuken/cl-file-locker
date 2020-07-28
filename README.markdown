# Cl-File-Locker

## Purpose

Manage and logging file operations.

This Library is not direct manage over the files.

## Usage

```lisp

(cl-file-locker:define-operations '((contents :type string) (created :type keyword)))

```

After the command is executed, define operations.

Operations is book-detail(struct), lock(function), unlock(function), to-string(function).

### book-detail

book-detail is struct, and *file-lock-management-book*(hash-table) value.

### lock, unlock

Operating functions in *file-lock-management-book*.

This functions result:

```
(<RESULT-KEYWORD> . <value>)
```

#### result-keyword

##### unlock

* SUCCESS_UNLOCK

Success unlock.

* NOT_LOCKED

Failed unlock. Not locking file.

##### lock

* ALREADY_LOCKED

Failed locking. File is already locked.

* SUCCESS_LOCK

Success lock.

### unlock

### to-string

## Installation

## Fxxk Points

* dependency with  [wasuken/mylib](https://github.com/wasuken/mylib).

* function:[define-operates], too long :(.
