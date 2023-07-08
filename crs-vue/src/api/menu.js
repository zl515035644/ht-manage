import http from '@/utils/request';

/**
 * 查询部门列表
 * @param params
 * @returns
 */
export default {
  async getMenuList(params){
    console.log(params + "这是前端Menu传过来的数据")
    return http.get('/api/permission/list', params);
  },
  async getParentMenuList(params){
    return http.get('/api/permission/parent/list', params);
  },
  async addMenu(params){
    return http.post('/api/permission/add', params);
  },
  async updateMenu(params){
    return http.put('/api/permission/update', params);
  },
  async checkPermission(params){
    return http.getRestApi('/api/permission/check', params);
  },async deleteById(params){
    return http.delete('/api/permission/delete', params);
  },
}
