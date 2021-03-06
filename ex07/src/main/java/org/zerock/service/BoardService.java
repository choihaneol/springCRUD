package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {

	public void register(BoardVO board);

	public BoardVO get(Long bno);

	public boolean modify(BoardVO board);

	public boolean remove(Long bno);

	public List<BoardVO> getList(Criteria cri); //Criteria를 파라미터로 처리

	public int getTotal(Criteria cri);
	
	public List<BoardAttachVO> getAttachList(Long bno); //게시물의 첨부파일목록 가져오기 

	
	
}
