<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<table class="easyui-datagrid" id="itemList" title="商品列表"
       data-options="singleSelect:false,collapsible:true,pagination:true,url:'/item/getItemByIdList',method:'get',toolbar:toolbar">
    <thead>
    <tr>
        <th data-options="field:'ck',checkbox:true"></th>
        <th data-options="field:'id',width:60">商品ID</th>
        <th data-options="field:'title',width:200">商品标题</th>
        <th data-options="field:'cid',width:100">叶子类目</th>
        <th data-options="field:'sellPoint',width:100">卖点</th>
        <th data-options="field:'price',width:70,align:'right',formatter:TAOTAO.formatPrice">价格</th>
        <th data-options="field:'num',width:70,align:'right'">库存数量</th>
        <th data-options="field:'barcode',width:100">条形码</th>
        <th data-options="field:'status',width:60,align:'center',formatter:TAOTAO.formatItemStatus">状态</th>
        <th data-options="field:'created',width:130,align:'center',formatter:TAOTAO.formatDateTime">创建日期</th>
        <th data-options="field:'updated',width:130,align:'center',formatter:TAOTAO.formatDateTime">更新日期</th>
    </tr>
    </thead>
</table>


<script>

    function getSelectionsIds() {
        var itemList = $("#itemList");
        var sels = itemList.datagrid("getSelections");
        var ids = [];
        for (var i in sels) {
            ids.push(sels[i].id);
        }
        ids = ids.join(",");
        return ids;
    }

    var toolbar = [{
        text: '新增',
        iconCls: 'icon-add',
        handler: function () {
            $(".tree-title:contains('新增商品')").parent().click();
        }

    }, {
        text: '编辑',
        iconCls: 'icon-edit',
        handler: function () {
            var ids = getSelectionsIds();
            if (ids.length == 0) {
                $.messager.alert('提示', '必须选择一个商品才能编辑!');
                return;
            }
            if (ids.indexOf(',') > 0) {
                $.messager.alert('提示', '只能选择一个商品!');
                return;
            }


            $('#tabs').tabs('add', {
                title: '编辑商品',
                closable: true,
                href: '${pageContext.request.contextPath}/rest/item-edit',
                onLoad: function () {
                    var data = $("#itemList").datagrid("getSelections")[0];
                    data.priceView = TAOTAO.formatPrice(data.price);
                    $("#itemeEditForm").form("load", data);
                }
            });


        }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function () {
            var ids = getSelectionsIds();
            if (ids.length == 0) {
                $.messager.alert('提示', '未选中商品!');
                return;
            }
            $.messager.confirm('确认', '确定删除ID为 ' + ids + ' 的商品吗？', function (r) {
                if (r) {
                    var params = {"ids": ids};
                    $.post("/item/deleteByIdMap", params, function (data) {
                        if (data.status == 200) {
                            $.messager.alert('提示', '删除商品成功!', undefined, function () {
                                $("#itemList").datagrid("reload");
                            });
                        }
                    });
                }
            });
        }
    }, '-', {
        text: '下架',
        iconCls: 'icon-remove',
        handler: function () {
            var ids = getSelectionsIds();
            if (ids.length == 0) {
                $.messager.alert('提示', '未选中商品!');
                return;
            }
            $.messager.confirm('确认', '确定下架ID为 ' + ids + ' 的商品吗？', function (r) {
                if (r) {
                    var params = {"ids": ids};
                    $.post("/rest/item/instock", params, function (data) {
                        if (data.status == 200) {
                            $.messager.alert('提示', '下架商品成功!', undefined, function () {
                                $("#itemList").datagrid("reload");
                            });
                        }
                    });
                }
            });
        }
    }, {
        text: '上架',
        iconCls: 'icon-remove',
        handler: function () {
            var ids = getSelectionsIds();
            if (ids.length == 0) {
                $.messager.alert('提示', '未选中商品!');
                return;
            }
            $.messager.confirm('确认', '确定上架ID为 ' + ids + ' 的商品吗？', function (r) {
                if (r) {
                    var params = {"ids": ids};
                    $.post("/rest/item/reshelf", params, function (data) {
                        if (data.status == 200) {
                            $.messager.alert('提示', '上架商品成功!', undefined, function () {
                                $("#itemList").datagrid("reload");
                            });
                        }
                    });
                }
            });
        }
    }, {
        text: '查询详情',
        iconCls: 'icon-search',
        handler: function () {
            var ids = getSelectionsIds();
            if (ids.length == 0) {
                $.messager.alert('提示', '必须选择一个商品才能查询!');
                return;
            }
            if (ids.indexOf(',') > 0) {
                $.messager.alert('提示', '只能选择一个商品!');
                return;
            }

            $('#tabs').tabs('add', {
                title: '查询详情',
                closable: true,
                href: '${pageContext.request.contextPath}/rest/item-search',
                onLoad: function () {
                    var data = $("#itemList").datagrid("getSelections")[0];
                    data.priceView = TAOTAO.formatPrice(data.price);
                    $("#itemeSearchForm").form("load", data);
                }
            });

        }
    }];
</script>
