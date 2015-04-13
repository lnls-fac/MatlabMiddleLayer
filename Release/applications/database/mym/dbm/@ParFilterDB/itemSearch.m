function [id, item] =  itemSearch(a_f, a_tag, a_parentId, a_parentTag)

id = itemSearch(a_f.BasicDB, a_tag, a_parentId, a_parentTag);
item = itemGet(a_f, id);