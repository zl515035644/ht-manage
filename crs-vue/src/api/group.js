import http from '@/utils/request'

/**
 * 查询镇村列表
 * @param params
 * @returns
 */
export default {
  async getGroupList(params) {
    return http.get("/api/group/getGroupList", params);
  },

}
