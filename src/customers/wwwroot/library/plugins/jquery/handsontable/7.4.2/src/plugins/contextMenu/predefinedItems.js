import { objectEach } from './../../helpers/object.js';
import alignmentItem, { KEY as ALIGNMENT } from './predefinedItems/alignment.js';
import clearColumnItem, { KEY as CLEAR_COLUMN } from './predefinedItems/clearColumn.js';
import columnLeftItem, { KEY as COLUMN_LEFT } from './predefinedItems/columnLeft.js';
import columnRightItem, { KEY as COLUMN_RIGHT } from './predefinedItems/columnRight.js';
import readOnlyItem, { KEY as READ_ONLY } from './predefinedItems/readOnly.js';
import redoItem, { KEY as REDO } from './predefinedItems/redo.js';
import removeColumnItem, { KEY as REMOVE_COLUMN } from './predefinedItems/removeColumn.js';
import removeRowItem, { KEY as REMOVE_ROW } from './predefinedItems/removeRow.js';
import rowAboveItem, { KEY as ROW_ABOVE } from './predefinedItems/rowAbove.js';
import rowBelowItem, { KEY as ROW_BELOW } from './predefinedItems/rowBelow.js';
import separatorItem, { KEY as SEPARATOR } from './predefinedItems/separator.js';
import noItemsItem, { KEY as NO_ITEMS } from './predefinedItems/noItems.js';
import undoItem, { KEY as UNDO } from './predefinedItems/undo.js';

export { KEY as ALIGNMENT } from './predefinedItems/alignment.js';
export { KEY as CLEAR_COLUMN } from './predefinedItems/clearColumn.js';
export { KEY as COLUMN_LEFT } from './predefinedItems/columnLeft.js';
export { KEY as COLUMN_RIGHT } from './predefinedItems/columnRight.js';
export { KEY as READ_ONLY } from './predefinedItems/readOnly.js';
export { KEY as REDO } from './predefinedItems/redo.js';
export { KEY as REMOVE_COLUMN } from './predefinedItems/removeColumn.js';
export { KEY as REMOVE_ROW } from './predefinedItems/removeRow.js';
export { KEY as ROW_ABOVE } from './predefinedItems/rowAbove.js';
export { KEY as ROW_BELOW } from './predefinedItems/rowBelow.js';
export { KEY as SEPARATOR } from './predefinedItems/separator.js';
export { KEY as NO_ITEMS } from './predefinedItems/noItems.js';
export { KEY as UNDO } from './predefinedItems/undo.js';

export const ITEMS = [
  ROW_ABOVE, ROW_BELOW, COLUMN_LEFT, COLUMN_RIGHT, CLEAR_COLUMN, REMOVE_ROW, REMOVE_COLUMN, UNDO, REDO, READ_ONLY,
  ALIGNMENT, SEPARATOR, NO_ITEMS
];

const _predefinedItems = {
  [SEPARATOR]: separatorItem,
  [NO_ITEMS]: noItemsItem,
  [ROW_ABOVE]: rowAboveItem,
  [ROW_BELOW]: rowBelowItem,
  [COLUMN_LEFT]: columnLeftItem,
  [COLUMN_RIGHT]: columnRightItem,
  [CLEAR_COLUMN]: clearColumnItem,
  [REMOVE_ROW]: removeRowItem,
  [REMOVE_COLUMN]: removeColumnItem,
  [UNDO]: undoItem,
  [REDO]: redoItem,
  [READ_ONLY]: readOnlyItem,
  [ALIGNMENT]: alignmentItem,
};

/**
 * Gets new object with all predefined menu items.
 *
 * @returns {Object}
 */
export function predefinedItems() {
  const items = {};

  objectEach(_predefinedItems, (itemFactory, key) => {
    items[key] = itemFactory();
  });

  return items;
}

/**
 * Add new predefined menu item to the collection.
 *
 * @param {String} key Menu command id.
 * @param {Object} item Object command descriptor.
 */
export function addItem(key, item) {
  if (ITEMS.indexOf(key) === -1) {
    _predefinedItems[key] = item;
  }
}
