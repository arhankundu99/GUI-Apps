// Have to do this in A* and implement the GUI

import java.io.*;
import java.util.*;

public class Solution {

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int k = scan.nextInt();
        
        int[] a = new int[k*k];
        for(int i = 0; i < a.length; i++){
            a[i] = scan.nextInt();
        }
        
        String initialConfig = "";
        String finalConfig = "";
        
        for(int i = 0; i < a.length; i++){
            initialConfig += a[i];
            finalConfig += i;   
        }
        
        Queue<String> queue = new LinkedList<>();
        Map<String, Integer> distMap = new HashMap<>();
        Map<String, String> parentMap = new HashMap<>();
        Map<String, Character> moveMap = new HashMap<>();
        
        char[] moves = new char[]{'L', 'R', 'U', 'D'};
        
        queue.add(initialConfig);
        distMap.put(initialConfig, 0);
        
        while(queue.size() != 0){
            String currentConfig = queue.poll();
            
            if(currentConfig.equals(finalConfig))break;
            
            int zerothIdx = getIdx(currentConfig, '0');
            
            for(char move: moves){
                if(isPossibleMove(currentConfig, move, k)){
                    
                    int swapIndex = getSwapIndex(currentConfig, move, k);
                    char[] currentConfigArray = currentConfig.toCharArray();
                    
                    swap(currentConfigArray, zerothIdx, swapIndex);
                    
                    String nextConfig = String.valueOf(currentConfigArray);
                    
                    if(distMap.containsKey(nextConfig))continue;
                    
                    distMap.put(nextConfig, distMap.get(currentConfig) + 1);
                    queue.add(nextConfig);
                    parentMap.put(nextConfig, currentConfig);
                    moveMap.put(nextConfig, move);
                }
            }
        }
        
        System.out.println(distMap.get(finalConfig));
        List<Character> movement = new ArrayList<>();
        
        String config = finalConfig;
        //printConfig(config, k);
        while(!parentMap.get(config).equals(initialConfig)){
            movement.add(0, moveMap.get(config));
            config = parentMap.get(config);
            //printConfig(config, k);
        }
        //printConfig(moveMap.get(config));
        movement.add(0, moveMap.get(config));
        
        for(int i = 0; i < movement.size(); i++){
            Character m = movement.get(i);
            if(m == 'L')
                System.out.println("LEFT");
            else if(m == 'U')
                System.out.println("UP");
            else if(m == 'D')
                System.out.println("DOWN");
            else
                System.out.println("RIGHT");
        }
    }
    
    public static int getIdx(String s, char c){
        for(int i = 0; i < s.length(); i++){
            if(s.charAt(i) == c)
                return i;
        }
        return -1;
    }
    
    public static void swap(char[] c, int i, int j){
        char temp = c[i];
        c[i] = c[j];
        c[j] = temp;
    }
    
    public static boolean isPossibleMove(String config, char move, int k){
        int zerothIdx = getIdx(config, '0');
        
        int row = zerothIdx / k, col = zerothIdx % k;
        
        if(move == 'L'){
            if(col == 0)return false;
            return true;
        }
        
        else if(move == 'R'){
            if(col == k - 1)return false;
            return true;
        }
        
        else if(move == 'U'){
            if(row == 0)return false;
            return true;
        }
        else{
            if(row == k - 1)return false;
            return true;
        }
    }
    
    public static int getSwapIndex(String config, char move, int k){
        int zerothIdx = getIdx(config, '0');
        
        int row = zerothIdx / k, col = zerothIdx % k;
        
        if(move == 'L'){
            return row * k + (col - 1);
        }
        
        else if(move == 'R'){
            return row * k + (col + 1);
        }
        
        else if(move == 'U'){
            return (row - 1) * k + col;
        }
        else{
            return (row + 1) * k + col;
        }
    }
    
    public static void printConfig(String config, int k){
        for(int i = 0; i < k; i++){
            for(int j = 0; j < k; j++){
                System.out.print(config.charAt(i * k + j));
            }
            System.out.println("");
        }
        System.out.println("\n\n");
    }
}
